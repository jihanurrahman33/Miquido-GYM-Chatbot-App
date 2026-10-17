import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/gym_facility_entity.dart';
import 'facility_chat_card.dart';
import 'quick_reply_chip.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final ValueChanged<String> onQuickReply;
  final ValueChanged<GymFacilityEntity> onFacilityTap;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onQuickReply,
    required this.onFacilityTap,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleWidget = message.isFromBot ? _buildBotBubble(context) : _buildUserBubble(context);
    return bubbleWidget.animate().fadeIn(duration: 250.ms).slideY(begin: 0.06, end: 0);
  }

  Widget _buildBotBubble(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bot Avatar
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 10, top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightBlueBg,
                  border: Border.all(color: AppTheme.facilityCardBorderSoft, width: 1),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  size: 18,
                  color: AppTheme.primaryBlue,
                ),
              ),

              // Bot Message Container
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: const BoxDecoration(
                    color: AppTheme.cardGray,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Optional Facility Card
          if (message.hasFacility)
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 4),
              child: FacilityChatCard(
                facility: message.facilityRecommendation!,
                onTap: () => onFacilityTap(message.facilityRecommendation!),
              ),
            ),

          // Optional Quick Reply Chips
          if (message.hasQuickReplies)
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: message.quickReplies.map((reply) {
                  return QuickReplyChip(
                    label: reply,
                    onTap: () => onQuickReply(reply),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.35,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
