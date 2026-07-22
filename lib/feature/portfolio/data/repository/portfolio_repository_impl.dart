import 'dart:convert';

import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/data/datasource/portfolio_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comments_page_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_feed_page_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_like_result_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  PortfolioRepositoryImpl({
    required PortfolioApiDatasource apiDatasource,
    required AuthSessionCubit authSessionCubit,
  }) : _apiDatasource = apiDatasource,
       _authSessionCubit = authSessionCubit;

  final PortfolioApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  @override
  bool get isGuest => _authSessionCubit.state.isAnonymous;

  void _ensureRegistered() {
    if (isGuest) {
      throw StateError(
        'Portfolio action is only available for registered users.',
      );
    }
  }

  @override
  Future<PortfolioFeedPageModel> fetchPublicFeed({
    required String seed,
    required int cursor,
    required int pageSize,
  }) {
    return _apiDatasource.fetchPublicFeed(
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
  }) async {
    _ensureRegistered();
    final page = await _apiDatasource.fetchUserFeed(
      seed: seed,
      cursor: cursor,
      pageSize: pageSize,
    );
    return _resolvePageOwnership(page);
  }

  @override
  Future<PortfolioFeedPageModel> fetchMyPosts({
    required int pageNumber,
    required int pageSize,
  }) async {
    _ensureRegistered();
    final page = await _apiDatasource.fetchMyPosts(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    return _resolvePageOwnership(page, forceOwned: true);
  }

  @override
  Future<PortfolioPostModel> fetchById(String id) async {
    final post = await _apiDatasource.fetchById(id);
    return _resolvePostOwnership(post);
  }

  PortfolioFeedPageModel _resolvePageOwnership(
    PortfolioFeedPageModel page, {
    bool forceOwned = false,
  }) {
    return PortfolioFeedPageModel(
      items: page.items
          .map((post) => _resolvePostOwnership(post, forceOwned: forceOwned))
          .toList(growable: false),
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    );
  }

  PortfolioPostModel _resolvePostOwnership(
    PortfolioPostModel post, {
    bool forceOwned = false,
  }) {
    if (forceOwned || post.isOwnedByCurrentUser) {
      return post.copyWith(isOwnedByCurrentUser: true);
    }
    final currentUserId = _currentUserId;
    if (currentUserId == null) return post;
    final authorId = post.author.id.trim().toLowerCase();
    return post.copyWith(
      isOwnedByCurrentUser: authorId.isNotEmpty && authorId == currentUserId,
    );
  }

  String? get _currentUserId {
    final token = _authSessionCubit.state.accessToken?.trim();
    if (token == null || token.isEmpty) return null;
    final parts = token.split('.');
    if (parts.length < 2) return null;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is! Map<String, dynamic>) return null;
      final nestedUser = payload['user'];
      final rawId =
          payload['sub'] ??
          payload['userId'] ??
          payload['user_id'] ??
          payload['uid'] ??
          payload['id'] ??
          (nestedUser is Map<String, dynamic>
              ? nestedUser['id'] ?? nestedUser['userId']
              : null);
      final id = rawId?.toString().trim().toLowerCase();
      return id == null || id.isEmpty ? null : id;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<PortfolioLikeResultModel> like(String id) {
    _ensureRegistered();
    return _apiDatasource.like(id);
  }

  @override
  Future<void> deletePost(String id) {
    _ensureRegistered();
    return _apiDatasource.deletePost(id);
  }

  @override
  Future<String> uploadMedia(String localFilePath) {
    _ensureRegistered();
    return _apiDatasource.uploadMedia(localFilePath);
  }

  @override
  Future<void> createPost({
    required String caption,
    required List<PortfolioCreateMediaInput> media,
  }) {
    _ensureRegistered();
    return _apiDatasource.createPost(caption: caption, media: media);
  }

  @override
  Future<PortfolioCommentsPageModel> fetchComments({
    required String postId,
    required int pageNumber,
    required int pageSize,
  }) {
    return _apiDatasource.fetchComments(
      postId: postId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<PortfolioCommentsPageModel> fetchReplies({
    required String postId,
    required String commentId,
    required int pageNumber,
    required int pageSize,
  }) {
    return _apiDatasource.fetchReplies(
      postId: postId,
      commentId: commentId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<void> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) {
    _ensureRegistered();
    return _apiDatasource.addComment(
      postId: postId,
      content: content,
      parentId: parentId,
    );
  }
}
