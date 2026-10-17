class NotificationItemEntity {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String type; // 'workout', 'booking', 'stat'
  final bool isRead;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  NotificationItemEntity copyWith({bool? isRead}) {
    return NotificationItemEntity(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
