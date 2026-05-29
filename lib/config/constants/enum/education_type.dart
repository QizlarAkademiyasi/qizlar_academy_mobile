enum EducationType {
  school('Maktab'),
  college('Kollej / Litsey'),
  university('Universitet'),
  none("Hozir o'qimayman");

  const EducationType(this.label);
  final String label;

  String get apiValue {
    switch (this) {
      case EducationType.school:
        return 'school';
      case EducationType.college:
        return 'college';
      case EducationType.university:
        return 'university';
      case EducationType.none:
        return 'none';
    }
  }

  /// `PATCH /user/me` dagi `educationId`. Backend katalogi bilan mos kelishi kerak.
  int get patchEducationId {
    switch (this) {
      case EducationType.school:
        return 1;
      case EducationType.college:
        return 2;
      case EducationType.university:
        return 3;
      case EducationType.none:
        return 0;
    }
  }

  /// `GET /user/me` `education` / `educaton` `type` (masalan `SCHOOL`, `school`).
  static EducationType? tryParseFromApi(String raw) {
    switch (raw.trim().toUpperCase()) {
      case 'SCHOOL':
        return EducationType.school;
      case 'COLLEGE':
        return EducationType.college;
      case 'UNIVERSITY':
        return EducationType.university;
      case 'NONE':
        return EducationType.none;
      default:
        return null;
    }
  }
}
