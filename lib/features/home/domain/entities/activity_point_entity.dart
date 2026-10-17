class ActivityPointEntity {
  final String dayShort;
  final double durationHours;
  final String tooltipText;
  final bool isPeak;

  const ActivityPointEntity({
    required this.dayShort,
    required this.durationHours,
    required this.tooltipText,
    this.isPeak = false,
  });
}
