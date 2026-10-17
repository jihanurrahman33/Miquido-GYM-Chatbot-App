import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../controllers/notification_controller.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppTheme.darkText, size: 20),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.darkText),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: AppTheme.primaryBlue),
            tooltip: 'Mark all read',
            onPressed: controller.markAllAsRead,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const EmptyStateView(
            icon: Icons.notifications_off_outlined,
            title: 'All Caught Up!',
            subtitle: 'You have no pending notifications right now.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final n = controller.notifications[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: n.isRead ? Colors.white : AppTheme.lightBlueBg.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: n.isRead ? AppTheme.borderLight : const Color(0xFFBFDDFF),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      n.type == 'workout'
                          ? Icons.fitness_center_rounded
                          : n.type == 'booking'
                              ? Icons.confirmation_number_rounded
                              : Icons.insights_rounded,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              n.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkText,
                              ),
                            ),
                            Text(
                              n.timeAgo,
                              style: const TextStyle(fontSize: 12, color: AppTheme.lightText),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n.message,
                          style: const TextStyle(fontSize: 13, color: AppTheme.bodyText, height: 1.35),
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
    );
  }
}
