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
  }) {
    _ensureRegistered();
    return _apiDatasource.fetchUserFeed(
      seed: seed,
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  @override
  Future<PortfolioPostModel> fetchById(String id) {
    return _apiDatasource.fetchById(id);
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
