enum AnnouncementType {
  course,
  social;

  static AnnouncementType fromApi(Object? value) {
    return value?.toString().trim().toUpperCase() == 'SOCIAL'
        ? AnnouncementType.social
        : AnnouncementType.course;
  }
}

class AnnouncementModel {
  const AnnouncementModel({
    required this.viewId,
    required this.type,
    required this.photoUrl,
    this.link,
    this.courseId,
    this.courseName,
  });

  final String viewId;
  final AnnouncementType type;
  final String photoUrl;
  final String? link;
  final String? courseId;
  final String? courseName;
}

class AnnouncementNextResult {
  const AnnouncementNextResult({
    required this.announcement,
    required this.hasMore,
  });

  final AnnouncementModel? announcement;
  final bool hasMore;
}
