import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart' show UserApis;
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';

class NotificationApiDatasource implements NotificationDatasource {
  const NotificationApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<List<NotificationSectionModel>> fetchNotificationSections() async {
    final response = await _dio.get<dynamic>(UserApis.notifications);
    return _parseSections(response.data);
  }

  @override
  Future<List<NotificationSectionModel>> markAllAsRead() async {
    await _dio.post<dynamic>(UserApis.notificationsReadAll);
    return fetchNotificationSections();
  }

  @override
  Future<void> markAsRead({required String notificationId}) async {
    await _dio.post<dynamic>(UserApis.notificationsReadById(notificationId));
  }

  List<NotificationSectionModel> _parseSections(dynamic data) {
    final envelope = _asMap(data);
    final payload = _asMap(envelope['data']);
    final rawList = _asList(payload['data']);

    final items = rawList
        .map((item) {
          final createdAt =
              DateTime.tryParse((item['createdAt'] ?? '').toString()) ??
              DateTime.now();
          final type = (item['type'] ?? '').toString().toLowerCase();
          final channel = type == 'global'
              ? NotificationChannelType.global
              : NotificationChannelType.push;
          final photo = (item['photo'] ?? '').toString().trim();
          final targetRaw = item['targetId'];
          final targetId = targetRaw == null
              ? null
              : targetRaw.toString().trim().isEmpty
              ? null
              : targetRaw.toString();

          return NotificationItemModel(
            id: (item['id'] ?? '').toString(),
            title: (item['title'] ?? '').toString(),
            description: (item['body'] ?? '').toString(),
            timeLabel: _formatRelativeTime(createdAt),
            createdAt: createdAt,
            channelType: channel,
            isRead: item['isRead'] == true || item['is_read'] == true,
            avatarUrl: photo.isEmpty ? null : photo,
            targetId: targetId,
          );
        })
        .toList(growable: false);

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final grouped = <String, List<NotificationItemModel>>{};
    for (final item in items) {
      final title = _sectionTitle(item.createdAt);
      grouped.putIfAbsent(title, () => <NotificationItemModel>[]).add(item);
    }

    final sections = grouped.entries
        .map(
          (entry) =>
              NotificationSectionModel(title: entry.key, items: entry.value),
        )
        .toList(growable: false);

    sections.sort(_compareSections);
    return sections;
  }

  int _compareSections(NotificationSectionModel a, NotificationSectionModel b) {
    final ra = _sectionRank(a.title);
    final rb = _sectionRank(b.title);
    if (ra != rb) return ra.compareTo(rb);
    final da = a.items
        .map((e) => e.createdAt)
        .reduce((x, y) => x.isAfter(y) ? x : y);
    final db = b.items
        .map((e) => e.createdAt)
        .reduce((x, y) => x.isAfter(y) ? x : y);
    return db.compareTo(da);
  }

  int _sectionRank(String title) {
    if (title == 'Bugun') return 0;
    if (title == 'Kecha') return 1;
    return 2;
  }

  String _sectionTitle(DateTime createdAt) {
    final now = DateTime.now();
    final localCreatedAt = createdAt.toLocal();
    final localNow = now.toLocal();
    final createdDate = DateTime(
      localCreatedAt.year,
      localCreatedAt.month,
      localCreatedAt.day,
    );
    final nowDate = DateTime(localNow.year, localNow.month, localNow.day);
    final diffDays = nowDate.difference(createdDate).inDays;
    if (diffDays == 0) return 'Bugun';
    if (diffDays == 1) return 'Kecha';
    return '${localCreatedAt.day.toString().padLeft(2, '0')}.${localCreatedAt.month.toString().padLeft(2, '0')}.${localCreatedAt.year}';
  }

  String _formatRelativeTime(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt.toLocal());
    if (difference.inMinutes < 1) return 'Hozirgina';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} daqiqa oldin';
    }
    if (difference.inHours < 24) return '${difference.inHours} soat oldin';
    return '${difference.inDays} kun oldin';
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_asMap).toList(growable: false);
  }
}
