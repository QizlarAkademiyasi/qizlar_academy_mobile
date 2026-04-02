import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
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
  Future<List<NotificationSectionModel>> markAsRead({
    required String notificationId,
  }) async {
    await _dio.post<dynamic>(UserApis.notificationsReadById(notificationId));
    return fetchNotificationSections();
  }

  List<NotificationSectionModel> _parseSections(dynamic data) {
    final envelope = _asMap(data);
    final payload = _asMap(envelope['data']);
    final items = _asList(payload['data']).map((item) {
      final createdAt =
          DateTime.tryParse((item['createdAt'] ?? '').toString()) ?? DateTime.now();
      final type = (item['type'] ?? '').toString().toLowerCase();
      final photo = (item['photo'] ?? '').toString();
      final isSystem = type == 'system' || photo.isEmpty;
      return NotificationItemModel(
        id: (item['id'] ?? '').toString(),
        title: (item['title'] ?? '').toString(),
        description: (item['body'] ?? '').toString(),
        timeLabel: _formatRelativeTime(createdAt),
        createdAt: createdAt,
        senderType: isSystem
            ? NotificationSenderType.system
            : NotificationSenderType.user,
        isRead: item['isRead'] == true,
        avatarUrl: photo.isEmpty ? null : photo,
      );
    }).toList(growable: false);

    final grouped = <String, List<NotificationItemModel>>{};
    for (final item in items) {
      final title = _sectionTitle(item.createdAt);
      grouped.putIfAbsent(title, () => <NotificationItemModel>[]).add(item);
    }

    return grouped.entries
        .map(
          (entry) => NotificationSectionModel(
            title: entry.key,
            items: entry.value,
          ),
        )
        .toList(growable: false);
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
    if (difference.inMinutes < 60) return '${difference.inMinutes} daqiqa oldin';
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
