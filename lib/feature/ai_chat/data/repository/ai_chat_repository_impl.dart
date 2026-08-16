import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  const AiChatRepositoryImpl(this._datasource);

  final AiChatDatasource _datasource;

  @override
  Future<AiChatBootstrapModel> bootstrap() => _datasource.bootstrap();

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
    required String locale,
    required String timezone,
  }) {
    return _datasource.sendMessage(
      conversationId: conversationId,
      clientMessageId: clientMessageId,
      message: message,
      locale: locale,
      timezone: timezone,
    );
  }
}
