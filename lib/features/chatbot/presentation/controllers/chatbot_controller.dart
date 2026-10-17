import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/gym_facility_entity.dart';
import '../../domain/usecases/chat_usecases.dart';
import '../../../../routes/app_routes.dart';

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
  final RxBool isRecordingAudio = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? _recordingTimer;

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
    _recordingTimer?.cancel();
    super.onClose();
  }

  Future<void> loadHistory() async {
    try {
      final result = await getChatHistoryUseCase.execute();
      result.when(
        success: (history) {
          messages.assignAll(history);
          _scrollToBottom();
        },
        failure: (_) {},
      );
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
      await Future.delayed(const Duration(milliseconds: 600));
      final result = await sendChatMessageUseCase.execute(text);

      result.when(
        success: (botMsg) {
          final updated = getChatHistoryUseCase.execute();
          updated.then((res) {
            res.when(
              success: (list) {
                messages.assignAll(list);
                _scrollToBottom();
              },
              failure: (_) {},
            );
          });
        },
        failure: (fail) {
          Get.snackbar('FitBot', fail.message);
        },
      );
    } finally {
      isTyping.value = false;
    }
  }

  void onQuickReplyTapped(String reply) {
    if (reply.toLowerCase().contains('start workout tracker')) {
      Get.toNamed(AppRoutes.workoutTracker);
      return;
    } else if (reply.toLowerCase().contains('view my active pass') || reply.toLowerCase().contains('bookings')) {
      Get.toNamed(AppRoutes.bookings);
      return;
    }
    sendMessage(reply);
  }

  void toggleVoiceRecording() {
    if (isRecordingAudio.value) {
      _stopVoiceRecording();
    } else {
      _startVoiceRecording();
    }
  }

  void _startVoiceRecording() {
    isRecordingAudio.value = true;
    recordingSeconds.value = 0;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingSeconds.value++;
      if (recordingSeconds.value >= 4) {
        _stopVoiceRecording(sendSimulation: true);
      }
    });
  }

  void _stopVoiceRecording({bool sendSimulation = false}) {
    _recordingTimer?.cancel();
    isRecordingAudio.value = false;
    if (sendSimulation) {
      sendMessage('Suggest cardio exercises for today');
    }
  }

  void bookFacility(GymFacilityEntity facility) {
    if (Get.context != null) {
      openBookingModal(Get.context!, facility);
    }
  }

  void openBookingModal(BuildContext context, GymFacilityEntity facility) {
    final selectedSlot = 'Today at 04:00 PM'.obs;
    final availableSlots = [
      'Today at 10:00 AM',
      'Today at 02:00 PM',
      'Today at 04:00 PM',
      'Today at 06:30 PM',
      'Tomorrow at 09:00 AM',
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Book a Gym Visit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              facility.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0070F0),
              ),
            ),
            Text(
              '${facility.address} • ${facility.priceInfo}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF72777A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Preferred Time Slot',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableSlots.map((slot) {
                  final isSelected = selectedSlot.value == slot;
                  return ChoiceChip(
                    label: Text(slot),
                    selected: isSelected,
                    selectedColor: const Color(0xFFEFF6FF),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0070F0) : const Color(0xFF303437),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF0070F0) : const Color(0xFFE5E7EB),
                    ),
                    onSelected: (_) => selectedSlot.value = slot,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await confirmBooking(
                    facility: facility,
                    slotTime: selectedSlot.value,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0070F0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Confirm Reservation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> confirmBooking({
    required GymFacilityEntity facility,
    required String slotTime,
  }) async {
    final result = await bookGymFacilityUseCase.execute(
      facilityId: facility.id,
      facilityName: facility.name,
      facilityAddress: facility.address,
      slotTime: slotTime,
      price: facility.priceInfo,
    );

    result.when(
      success: (booking) {
        Get.snackbar(
          'Pass Confirmed! 🎟️',
          '${facility.name} pass booked for $slotTime.',
          backgroundColor: const Color(0xFF0070F0),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () => Get.toNamed(AppRoutes.bookings),
            child: const Text('VIEW PASS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        );
        sendMessage('I just confirmed my pass for ${facility.name} at $slotTime');
      },
      failure: (fail) {
        Get.snackbar('Booking Error', fail.message);
      },
    );
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
