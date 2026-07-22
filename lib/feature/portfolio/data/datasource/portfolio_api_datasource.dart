import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/data/datasource/portfolio_datasource.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_author_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comment_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comments_page_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_feed_page_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_like_result_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

class PortfolioApiDatasource implements PortfolioDatasource {
  const PortfolioApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<PortfolioFeedPageModel> fetchPublicFeed({
    required String seed,
    required int cursor,
    required int pageSize,
  }) {
    return _fetchFeed(
      PortfolioApis.publicFeed,
      seed: seed,
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  @override
  Future<PortfolioFeedPageModel> fetchUserFeed({
    required String seed,
    required int cursor,
    required int pageSize,
  }) {
    return _fetchFeed(
      PortfolioApis.feed,
      seed: seed,
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  @override
  Future<PortfolioFeedPageModel> fetchMyPosts({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      PortfolioApis.myPosts,
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return parseMyPostsPayload(response.data, fallbackPageSize: pageSize);
  }

  Future<PortfolioFeedPageModel> _fetchFeed(
    String path, {
    required String seed,
    required int cursor,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: <String, dynamic>{
        'seed': seed,
        'cursor': cursor,
        'pageSize': pageSize,
      },
    );
    return parseFeedPayload(response.data);
  }

  PortfolioFeedPageModel parseFeedPayload(dynamic payload) {
    final envelope = _asMap(payload);
    final data = _asMap(envelope['data']);
    final items = _asList(data['data']).map(_mapPost).toList(growable: false);
    return PortfolioFeedPageModel(
      items: items,
      nextCursor: _parseInt(data['nextCursor']),
      hasMore: _parseBool(data['hasMore']),
    );
  }

  PortfolioFeedPageModel parseMyPostsPayload(
    dynamic payload, {
    required int fallbackPageSize,
  }) {
    final envelope = _asMap(payload);
    final data = _asMap(envelope['data']);
    final items = _asList(data['data'])
        .map(
          (item) => _mapPost(_asMap(item)).copyWith(isOwnedByCurrentUser: true),
        )
        .toList(growable: false);
    final meta = _asMap(data['meta']);
    final pagination = _asMap(meta['pagination']);
    if (pagination.isEmpty) {
      return PortfolioFeedPageModel(
        items: items,
        nextCursor: 1,
        hasMore: false,
      );
    }
    final pageNumber = _parseInt(pagination['pageNumber']).clamp(1, 1 << 30);
    final rawPageCount = _parseInt(pagination['pageCount']);
    final pageCount = rawPageCount <= 0 ? 1 : rawPageCount;
    final hasMore = pageNumber < pageCount;
    return PortfolioFeedPageModel(
      items: items,
      nextCursor: hasMore ? pageNumber + 1 : pageNumber,
      hasMore: hasMore,
    );
  }

  @override
  Future<PortfolioPostModel> fetchById(String id) async {
    final response = await _dio.get<dynamic>(PortfolioApis.postById(id));
    final envelope = _asMap(response.data);
    return _mapPost(_asMap(envelope['data']));
  }

  @override
  Future<PortfolioLikeResultModel> like(String id) async {
    final response = await _dio.post<dynamic>(PortfolioApis.like(id), data: '');
    return parseLikePayload(response.data);
  }

  PortfolioLikeResultModel parseLikePayload(dynamic payload) {
    final envelope = _asMap(payload);
    final data = _asMap(envelope['data']);
    return PortfolioLikeResultModel(
      isLiked: _parseBool(data['isLiked']),
      likesCount: _parseInt(data['likesCount']),
    );
  }

  @override
  Future<void> deletePost(String id) async {
    await _dio.delete<dynamic>(PortfolioApis.postById(id));
  }

  @override
  Future<String> uploadMedia(String localFilePath) async {
    final segments = localFilePath.replaceAll(r'\', '/').split('/');
    final filename = segments.isNotEmpty ? segments.last : 'portfolio-media';
    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(localFilePath, filename: filename),
    });
    final response = await _dio.post<dynamic>(
      UserApis.fileUpload,
      data: formData,
    );
    return _parseUploadedFilename(response.data);
  }

  @override
  Future<void> createPost({
    required String caption,
    required List<PortfolioCreateMediaInput> media,
  }) async {
    await _dio.post<dynamic>(
      PortfolioApis.posts,
      data: <String, dynamic>{
        'caption': caption.trim().isEmpty ? null : caption.trim(),
        'media': media
            .map(
              (item) => <String, dynamic>{
                'type': item.type.apiValue,
                'url': item.url,
                'thumbnail': item.thumbnail,
                'duration': item.duration,
                'orderIndex': item.orderIndex,
              },
            )
            .toList(growable: false),
      },
    );
  }

  @override
  Future<PortfolioCommentsPageModel> fetchComments({
    required String postId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      PortfolioApis.comments(postId),
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return parseCommentsPayload(response.data);
  }

  @override
  Future<PortfolioCommentsPageModel> fetchReplies({
    required String postId,
    required String commentId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      PortfolioApis.replies(postId: postId, commentId: commentId),
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return parseCommentsPayload(response.data);
  }

  @override
  Future<void> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    await _dio.post<dynamic>(
      PortfolioApis.comments(postId),
      data: <String, dynamic>{'content': content.trim(), 'parentId': parentId},
    );
  }

  PortfolioCommentsPageModel parseCommentsPayload(dynamic payload) {
    final envelope = _asMap(payload);
    final data = _asMap(envelope['data']);
    final items = _asList(
      data['data'],
    ).map(_mapComment).toList(growable: false);
    final meta = _asMap(data['meta']);
    final pagination = _asMap(meta['pagination']);
    final pageCount = _parseInt(pagination['pageCount']);
    return PortfolioCommentsPageModel(
      items: items,
      pageNumber: _parseInt(pagination['pageNumber']).clamp(1, 1 << 30),
      pageSize: _parseInt(pagination['pageSize']).clamp(1, 500),
      totalCount: _parseInt(pagination['count']),
      pageCount: pageCount <= 0 ? 1 : pageCount,
    );
  }

  PortfolioPostModel _mapPost(Map<String, dynamic> m) {
    final author = _asMap(m['author']);
    final media = _asList(m['media']).map(_mapMedia).toList(growable: false)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return PortfolioPostModel(
      id: (m['id'] ?? '').toString(),
      caption: (m['caption'] ?? '').toString(),
      viewsCount: _parseInt(m['viewsCount']),
      likesCount: _parseInt(m['likesCount']),
      commentsCount: _parseInt(m['commentsCount']),
      createdAt: _parseDate(m['createdAt']),
      author: PortfolioAuthorModel(
        id: (author['id'] ?? '').toString(),
        firstname: (author['firstname'] ?? '').toString(),
        lastname: (author['lastname'] ?? '').toString(),
        photoUrl: Apis.resolveUrl((author['photo'] ?? '').toString()),
      ),
      media: media,
      isLiked: _parseBool(m['isLiked']),
      isOwnedByCurrentUser: _parseBool(
        m['isOwnedByCurrentUser'] ??
            m['isOwner'] ??
            m['isMine'] ??
            m['isOwn'] ??
            m['isMyPost'],
      ),
    );
  }

  PortfolioMediaModel _mapMedia(Map<String, dynamic> m) {
    return PortfolioMediaModel(
      id: (m['id'] ?? '').toString(),
      type: PortfolioMediaType.fromApi((m['type'] ?? '').toString()),
      url: Apis.resolveUrl((m['url'] ?? '').toString()),
      thumbnailUrl: Apis.resolveUrl((m['thumbnail'] ?? '').toString()),
      duration: m['duration'] == null ? null : _parseInt(m['duration']),
      orderIndex: _parseInt(m['orderIndex']),
    );
  }

  PortfolioCommentModel _mapComment(Map<String, dynamic> m) {
    final author = _asMap(m['author']);
    final parentRaw = m['parentId'];
    final parentId = parentRaw?.toString();
    return PortfolioCommentModel(
      id: (m['id'] ?? '').toString(),
      content: (m['content'] ?? '').toString(),
      parentId: parentId != null && parentId.trim().isEmpty ? null : parentId,
      createdAt: _parseDate(m['createdAt']),
      author: PortfolioAuthorModel(
        id: (author['id'] ?? '').toString(),
        firstname: (author['firstname'] ?? '').toString(),
        lastname: (author['lastname'] ?? '').toString(),
        photoUrl: Apis.resolveUrl((author['photo'] ?? '').toString()),
      ),
    );
  }

  String _parseUploadedFilename(dynamic raw) {
    final root = _asMap(raw);
    final dataField = root['data'];
    if (dataField is String && dataField.trim().isNotEmpty) {
      return dataField.trim();
    }
    final nested = _asMap(dataField);
    final inner = nested['data'];
    if (inner is String && inner.trim().isNotEmpty) {
      return inner.trim();
    }
    throw FormatException('Unexpected file upload payload', raw);
  }

  DateTime _parseDate(dynamic value) {
    final text = (value ?? '').toString().trim();
    if (text.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    }
    return DateTime.tryParse(text)?.toLocal() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    if (data != null) {
      AppLogger.w(
        'PortfolioApiDatasource: expected map, got ${data.runtimeType}',
      );
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic data) {
    if (data is! List) return const [];
    return data.map(_asMap).where((m) => m.isNotEmpty).toList(growable: false);
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('${value ?? 0}') ?? 0;
  }

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final lower = value.toString().toLowerCase();
    return lower == 'true' || lower == '1';
  }
}
