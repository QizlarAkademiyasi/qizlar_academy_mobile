part of 'courses_catalog_bloc.dart';

sealed class CoursesCatalogEvent extends Equatable {
  const CoursesCatalogEvent();

  @override
  List<Object?> get props => [];
}

final class CoursesCatalogStarted extends CoursesCatalogEvent {
  const CoursesCatalogStarted({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}

final class CoursesCatalogRetryRequested extends CoursesCatalogEvent {
  const CoursesCatalogRetryRequested();
}

final class CoursesCatalogSearchChanged extends CoursesCatalogEvent {
  const CoursesCatalogSearchChanged({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}
