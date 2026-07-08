import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class PortfolioLikeResultModel extends Equatable {
  const PortfolioLikeResultModel({
    required this.isLiked,
    required this.likesCount,
  });

  final bool isLiked;
  final int likesCount;

  @override
  List<Object?> get props => [isLiked, likesCount];
}
