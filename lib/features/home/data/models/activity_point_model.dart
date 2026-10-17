import '../../domain/entities/activity_point_entity.dart';

class ActivityPointModel extends ActivityPointEntity {
  const ActivityPointModel({
    required super.dayShort,
    required super.durationHours,
    required super.tooltipText,
    super.isPeak,
  });

  factory ActivityPointModel.fromJson(Map<String, dynamic> json) {
    return ActivityPointModel(
      dayShort: json['dayShort'] as String,
      durationHours: (json['durationHours'] as num).toDouble(),
      tooltipText: json['tooltipText'] as String,
      isPeak: json['isPeak'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayShort': dayShort,
      'durationHours': durationHours,
      'tooltipText': tooltipText,
      'isPeak': isPeak,
    };
  }
}
