class ScheduleModels {
  final int id;
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final bool isCompleted;

  ScheduleModels({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isCompleted,
  });

  factory ScheduleModels.fromJson(Map<String, dynamic> json) {
    return ScheduleModels(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'is_completed': isCompleted,
    };
  }
}
