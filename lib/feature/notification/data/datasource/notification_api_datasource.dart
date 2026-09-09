import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart' show UserApis;
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';

class NotificationApiDatasource implements NotificationDatasource {
  const NotificationApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      UserApis.notifications,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'type': type.apiValue,
      },
    );
    final payload = _payload(response.data);
    final items = _asList(payload['data'])
        .map((item) => _mapItem(item, fallbackType: type))
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return NotificationPageModel(
      items: items,
      pagination: _mapPagination(
        _asMap(_asMap(payload['meta'])['pagination']),
        pageNumber: pageNumber,
        pageSize: pageSize,
        fallbackCount: items.length,
      ),
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _dio.post<dynamic>(UserApis.notificationsReadAll);
  }

  @override
  Future<void> markAsRead({required String notificationId}) async {
    await _dio.post<dynamic>(UserApis.notificationsReadById(notificationId));
  }

  @override
  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      UserApis.notificationTopics,
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );
    final payload = _payload(response.data);
    final items = _asList(payload['data'])
        .map(
          (item) => NotificationTopicModel(
            id: (item['id'] ?? '').toString(),
            topic: (item['topic'] ?? '').toString(),
            isSubscribed: item['isSubscribed'] == true,
          ),
        )
        .where((item) => item.id.isNotEmpty)
        .toList(growable: false);
    return NotificationTopicPageModel(
      items: items,
      pagination: _mapPagination(
        _asMap(_asMap(payload['meta'])['pagination']),
        pageNumber: pageNumber,
        pageSize: pageSize,
        fallbackCount: items.length,
      ),
    );
  }

  @override
  Future<bool> toggleTopic({required String topicId}) async {
    final response = await _dio.post<dynamic>(
      UserApis.notificationTopicToggle(topicId),
    );
    final root = _asMap(response.data);
    final data = _asMap(root['data']);
    return data['isSubscribed'] == true;
  }

  NotificationItemModel _mapItem(
    Map<String, dynamic> item, {
    required NotificationChannelType fallbackType,
  }) {
    final createdAt =
        DateTime.tryParse((item['createdAt'] ?? '').toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    final type = (item['type'] ?? '').toString().toLowerCase();
    final channel = switch (type) {
      'global' => NotificationChannelType.global,
      'push' => NotificationChannelType.push,
      _ => fallbackType,
    };
    final photo = _nullableString(item['photo']);
    final targetId = _nullableString(item['targetId']);
    final category = NotificationCategory.fromApi(item['category']);
    final actors = _asList(item['actors'])
        .take(3)
        .map(
          (actor) => NotificationActorModel(
            id: (actor['id'] ?? '').toString(),
            firstName: (actor['firstname'] ?? '').toString(),
            lastName: (actor['lastname'] ?? '').toString(),
            photoUrl: _nullableString(actor['photo']),
          ),
        )
        .toList(growable: false);
    final postMap = item['post'] is Map ? _asMap(item['post']) : null;
    final postId = postMap == null ? null : _nullableString(postMap['id']);

    return NotificationItemModel(
      id: (item['id'] ?? '').toString(),
      title: (item['title'] ?? '').toString(),
      description: (item['body'] ?? '').toString(),
      createdAt: createdAt,
      channelType: channel,
      isRead: item['isRead'] == true || item['is_read'] == true,
      avatarUrl: photo,
      targetId: targetId,
      category: category,
      actors: actors,
      post: postId == null
          ? null
          : NotificationPostModel(
              id: postId,
              thumbnailUrl: _nullableString(postMap?['thumbnail']),
            ),
    );
  }

  NotificationPaginationModel _mapPagination(
    Map<String, dynamic> raw, {
    required int pageNumber,
    required int pageSize,
    required int fallbackCount,
  }) {
    final safePageNumber = _parseInt(raw['pageNumber'], pageNumber);
    final safePageSize = _parseInt(raw['pageSize'], pageSize);
    final count = _parseInt(raw['count'], fallbackCount);
    final pageCount = _parseInt(raw['pageCount'], 1).clamp(1, 1 << 31);
    return NotificationPaginationModel(
      pageNumber: safePageNumber,
      pageSize: safePageSize,
      count: count,
      pageCount: pageCount,
    );
  }

  Map<String, dynamic> _payload(dynamic raw) {
    final root = _asMap(raw);
    return _asMap(root['data']);
  }

  int _parseInt(dynamic raw, int fallback) {
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '') ?? fallback;
  }

  String? _nullableString(dynamic raw) {
    if (raw == null) return null;
    final value = raw.toString().trim();
    return value.isEmpty ? null : value;
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
