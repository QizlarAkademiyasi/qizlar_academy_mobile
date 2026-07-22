import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_author_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';

class PortfolioPostModel extends Equatable {
  const PortfolioPostModel({
    required this.id,
    required this.caption,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.author,
    required this.media,
    required this.isLiked,
    this.isOwnedByCurrentUser = false,
  });

  final String id;
  final String caption;
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final PortfolioAuthorModel author;
  final List<PortfolioMediaModel> media;
  final bool isLiked;
  final bool isOwnedByCurrentUser;

  PortfolioPostModel copyWith({
    String? id,
    String? caption,
    int? viewsCount,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    PortfolioAuthorModel? author,
    List<PortfolioMediaModel>? media,
    bool? isLiked,
    bool? isOwnedByCurrentUser,
  }) {
    return PortfolioPostModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      media: media ?? this.media,
      isLiked: isLiked ?? this.isLiked,
      isOwnedByCurrentUser: isOwnedByCurrentUser ?? this.isOwnedByCurrentUser,
    );
  }

  PortfolioPostModel toggledLike() {
    final nextLiked = !isLiked;
    return copyWith(
      isLiked: nextLiked,
      likesCount: (likesCount + (nextLiked ? 1 : -1)).clamp(0, 1 << 30),
    );
  }

  PortfolioPostModel applyLike({
    required bool isLiked,
    required int likesCount,
  }) {
    return copyWith(isLiked: isLiked, likesCount: likesCount.clamp(0, 1 << 30));
  }

  @override
  List<Object?> get props => [
    id,
    caption,
    viewsCount,
    likesCount,
    commentsCount,
    createdAt,
    author,
    media,
    isLiked,
    isOwnedByCurrentUser,
  ];
}
