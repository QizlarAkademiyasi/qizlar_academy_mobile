import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseCatalogItemModel extends Equatable {
  const CourseCatalogItemModel({
    required this.id,
    required this.title,
    required this.mentorName,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.durationSeconds,
    this.tagLabel,
  });

  final String id;
  final String title;
  final String mentorName;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final int durationSeconds;
  final String? tagLabel;

  @override
  List<Object?> get props => [id, title, mentorName, imageUrl, rating, reviewsCount, durationSeconds, tagLabel];
}
