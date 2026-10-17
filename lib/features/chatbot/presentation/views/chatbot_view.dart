import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/chatbot_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: AppTheme.borderLight, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Bot Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightBlueBg,
                    border: Border.all(color: const Color(0xFFD6E8FE), width: 1),
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    size: 24,
                    color: AppTheme.primaryBlue,
                  ),
                ),

                const SizedBox(width: 12),

                // Bot Name & Status
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FitBot',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.successGreen,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Always active',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // More Menu Button
                GestureDetector(
                  onTap: () => _showChatOptions(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: AppTheme.borderLight, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      size: 22,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: controller.messages.length + (controller.isTyping.value ? 2 : 1),
                itemBuilder: (context, index) {
                  // Index 0: Timestamp Header "Wed 8:21 AM"
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 4),
                      child: Center(
                        child: Text(
                          'Wed 8:21 AM',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightText,
                          ),
                        ),
                      ),
                    );
                  }

                  // Message Index
                  final msgIndex = index - 1;
                  if (msgIndex < controller.messages.length) {
                    final msg = controller.messages[msgIndex];
                    return ChatBubble(
                      message: msg,
                      onQuickReply: controller.onQuickReplyTapped,
                      onFacilityTap: (facility) {
                        Get.toNamed(
                          AppRoutes.facilityDetail,
                          arguments: facility,
                        );
                      },
                    );
                  }

                  // Typing indicator at bottom
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.lightBlueBg,
                          ),
                          child: const Icon(
                            Icons.smart_toy_rounded,
                            size: 18,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'FitBot is typing...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Bottom Input Bar
          ChatInputBar(
            controller: controller.inputController,
            onSend: () => controller.sendMessage(),
            onMicTap: () {
              Get.snackbar(
                'Voice Assistant',
                'Listening... (Voice command simulated)',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.navBarDark,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Wrap(
          runSpacing: 16,
          children: [
            const Text(
              'Chatbot Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            ListTile(
              leading: const Icon(Icons.refresh_rounded, color: AppTheme.primaryBlue),
              title: const Text('Reset Conversation'),
              subtitle: const Text('Restore default Figma example conversation'),
              onTap: () {
                Get.back();
                controller.loadHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center_rounded, color: AppTheme.primaryBlue),
              title: const Text('Quick Gym Pass Booking'),
              subtitle: const Text('Book immediate pass at nearby gym'),
              onTap: () {
                Get.back();
                controller.sendMessage('Book me a visit in a gym');
              },
            ),
          ],
        ),
      ),
    );
  }
}
