import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';

enum AiChatMessageRole { user, assistant }

enum AiChatMessageDelivery { sent, sending, failed }

class AiChatMessageModel extends Equatable {
  const AiChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.courses = const [],
    this.delivery = AiChatMessageDelivery.sent,
  });

  final String id;
  final AiChatMessageRole role;
  final String content;
  final DateTime createdAt;
  final List<AiChatCourseModel> courses;
  final AiChatMessageDelivery delivery;

  AiChatMessageModel copyWith({String? id, AiChatMessageDelivery? delivery}) {
    return AiChatMessageModel(
      id: id ?? this.id,
      role: role,
      content: content,
      createdAt: createdAt,
      courses: courses,
      delivery: delivery ?? this.delivery,
    );
  }

  @override
  List<Object?> get props => [id, role, content, createdAt, courses, delivery];
}
