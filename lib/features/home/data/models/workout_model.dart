import '../../domain/entities/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({
    required super.id,
    required super.title,
    required super.timeString,
    required super.category,
    required super.location,
    required super.bgColorHex,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      title: json['title'] as String,
      timeString: json['timeString'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      bgColorHex: (json['bgColorHex'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timeString': timeString,
      'category': category,
      'location': location,
      'bgColorHex': bgColorHex,
    };
  }
}
