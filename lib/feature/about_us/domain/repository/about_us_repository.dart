import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_us_page_model.dart';

abstract class AboutUsRepository {
  Future<AboutUsPageModel> loadAboutUs();
}
