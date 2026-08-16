import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class AiChatQuickReplyModel extends Equatable {
  const AiChatQuickReplyModel({
    required this.id,
    required this.label,
    required this.prompt,
  });

  final String id;
  final String label;
  final String prompt;

  @override
  List<Object?> get props => [id, label, prompt];
}
