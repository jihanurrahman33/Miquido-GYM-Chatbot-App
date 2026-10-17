import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/gym_facility_entity.dart';
import '../../domain/usecases/chat_usecases.dart';

class ChatbotController extends GetxController {
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final SendChatMessageUseCase sendChatMessageUseCase;
  final BookGymFacilityUseCase bookGymFacilityUseCase;

  ChatbotController({
    required this.getChatHistoryUseCase,
    required this.sendChatMessageUseCase,
    required this.bookGymFacilityUseCase,
  });

  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final RxBool isTyping = false.obs;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadHistory() async {
    try {
      final history = await getChatHistoryUseCase.execute();
      messages.assignAll(history);
      _scrollToBottom();
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> sendMessage([String? customText]) async {
    final text = (customText ?? inputController.text).trim();
    if (text.isEmpty) return;

    if (customText == null) {
      inputController.clear();
    }

    // Immediately push user message into UI
    final tempUserMsg = ChatMessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      sender: MessageSender.user,
      text: text,
      timestamp: DateTime.now(),
    );
    messages.add(tempUserMsg);
    _scrollToBottom();

    isTyping.value = true;

    try {
      // Small simulated delay for natural conversational UX
      await Future.delayed(const Duration(milliseconds: 600));
      await sendChatMessageUseCase.execute(text);

      // Re-fetch all to keep synchronized
      final updatedHistory = await getChatHistoryUseCase.execute();
      messages.assignAll(updatedHistory);
      _scrollToBottom();
    } catch (e) {
      Get.snackbar('FitBot', 'Failed to send message: $e');
    } finally {
      isTyping.value = false;
    }
  }

  void onQuickReplyTapped(String reply) {
    sendMessage(reply);
  }

  Future<void> bookFacility(GymFacilityEntity facility) async {
    try {
      final success = await bookGymFacilityUseCase.execute(
        facility.id,
        DateTime.now().add(const Duration(hours: 3)),
      );

      if (success) {
        Get.snackbar(
          'Booking Confirmed! 🎉',
          'Pass for ${facility.name} saved to your account.',
          backgroundColor: const Color(0xFF0070F0),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        // Also inform the bot conversation
        await sendMessage('Booked pass for ${facility.name}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to book facility: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
