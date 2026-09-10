import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';

abstract interface class AnnouncementRepository {
  Future<AnnouncementNextResult> fetchNext();

  Future<void> markClicked(String viewId);
}
