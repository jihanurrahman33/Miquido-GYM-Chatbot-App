class WorkoutEntity {
  final String id;
  final String title;
  final String timeString;
  final String category;
  final String location;
  final int bgColorHex;

  const WorkoutEntity({
    required this.id,
    required this.title,
    required this.timeString,
    required this.category,
    required this.location,
    required this.bgColorHex,
  });
}
