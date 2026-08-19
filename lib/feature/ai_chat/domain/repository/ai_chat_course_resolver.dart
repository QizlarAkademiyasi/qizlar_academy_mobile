import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';

abstract class AiChatCourseResolver {
  void remember(Iterable<AiChatCourseModel> courses);

  Future<List<AiChatCourseModel>> resolve(List<String> ids);
}
