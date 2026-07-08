import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_feed_page_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_comments_page_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_like_result_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';

abstract class PortfolioRepository {
  bool get isGuest;

  Future<PortfolioFeedPageModel> fetchPublicFeed({
    required String seed,
    required int cursor,
    required int pageSize,
  });

  Future<PortfolioFeedPageModel> fetchUserFeed({
    required String seed,
    required int cursor,
    required int pageSize,
  });

  Future<PortfolioFeedPageModel> fetchMyPosts({
    required int pageNumber,
    required int pageSize,
  });

  Future<PortfolioPostModel> fetchById(String id);

  Future<PortfolioLikeResultModel> like(String id);

  Future<void> deletePost(String id);

  Future<String> uploadMedia(String localFilePath);

  Future<void> createPost({
    required String caption,
    required List<PortfolioCreateMediaInput> media,
  });

  Future<PortfolioCommentsPageModel> fetchComments({
    required String postId,
    required int pageNumber,
    required int pageSize,
  });

  Future<PortfolioCommentsPageModel> fetchReplies({
    required String postId,
    required String commentId,
    required int pageNumber,
    required int pageSize,
  });

  Future<void> addComment({
    required String postId,
    required String content,
    String? parentId,
  });
}

class PortfolioCreateMediaInput {
  const PortfolioCreateMediaInput({
    required this.type,
    required this.url,
    this.thumbnail,
    this.duration,
    required this.orderIndex,
  });

  final PortfolioMediaType type;
  final String url;
  final String? thumbnail;
  final int? duration;
  final int orderIndex;
}
