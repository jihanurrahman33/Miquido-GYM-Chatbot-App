import '../entities/chat_message_entity.dart';
import '../repositories/i_chatbot_repository.dart';

class GetChatHistoryUseCase {
  final IChatbotRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<List<ChatMessageEntity>> execute() {
    return _repository.getChatHistory();
  }
}

class SendChatMessageUseCase {
  final IChatbotRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<ChatMessageEntity> execute(String text) {
    return _repository.sendMessage(text);
  }
}

class BookGymFacilityUseCase {
  final IChatbotRepository _repository;

  BookGymFacilityUseCase(this._repository);

  Future<bool> execute(String facilityId, DateTime preferredTime) {
    return _repository.bookFacility(facilityId, preferredTime);
  }
}
