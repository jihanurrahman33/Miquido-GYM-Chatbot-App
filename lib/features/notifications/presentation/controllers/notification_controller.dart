import 'package:get/get.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../domain/entities/notification_item_entity.dart';

class NotificationController extends GetxController {
  final RxList<NotificationItemEntity> notifications = <NotificationItemEntity>[
    const NotificationItemEntity(
      id: 'notif_1',
      title: 'Workout Reminder 🏋️',
      message: 'Your scheduled "Workout at Aleja Pokoju" starts at 2:45 PM today.',
      timeAgo: '15m ago',
      type: 'workout',
    ),
    const NotificationItemEntity(
      id: 'notif_2',
      title: 'Pass Ready: BodyWorks 🎟️',
      message: 'Your turnstile entry pass is active for today. Tap to view QR code.',
      timeAgo: '1h ago',
      type: 'booking',
    ),
    const NotificationItemEntity(
      id: 'notif_3',
      title: 'Goal Milestone Reached! 🚀',
      message: 'You have burnt 3,950 kcal this week! FitBot is proud of you.',
      timeAgo: 'Yesterday',
      type: 'stat',
      isRead: true,
    ),
  ].obs;

  void markAllAsRead() {
    notifications.assignAll(notifications.map((n) => n.copyWith(isRead: true)).toList());
    AppSnackbar.success('Notifications', 'All marked as read');
  }

  void clearAll() {
    notifications.clear();
  }
}
