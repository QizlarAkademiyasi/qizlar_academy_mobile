import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum TaskFrequency { once, daily, weekly, special, unknown }

enum TaskType { auto, manual, unknown }

enum TaskEvent {
  getCertificate,
  courseComplete,
  profileFill,
  writeCommitToCourse,
  createPortfolio,
  unknown,
}

class TaskItemModel extends Equatable {
  const TaskItemModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.coins,
    required this.frequency,
    required this.type,
    required this.event,
    required this.link,
    required this.requiredCount,
    required this.isActive,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
    required this.isCompleted,
    required this.completedCount,
  });

  factory TaskItemModel.fromJson(Map<String, dynamic> json) {
    final requiredCount = _parsePositiveInt(json['count'], fallback: 1);
    final completedCount = _parseNonNegativeInt(json['completedCount']);

    return TaskItemModel(
      id: (json['id'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString().trim(),
      title: (json['title'] ?? '').toString().trim(),
      description: (json['description'] ?? '').toString().trim(),
      coins: _parseNonNegativeInt(json['coins']),
      frequency: _parseFrequency(json['frequency']),
      type: _parseType(json['type']),
      event: _parseEvent(json['event']),
      link: (json['link'] ?? '').toString().trim(),
      requiredCount: requiredCount,
      isActive: _parseBool(json['isActive'], fallback: true),
      startsAt: DateTime.tryParse('${json['startsAt'] ?? ''}'),
      endsAt: DateTime.tryParse('${json['endsAt'] ?? ''}'),
      createdAt: DateTime.tryParse('${json['createdAt'] ?? ''}'),
      isCompleted:
          _parseBool(json['isCompleted']) || completedCount >= requiredCount,
      completedCount: completedCount,
    );
  }

  final String id;
  final String icon;
  final String title;
  final String description;
  final int coins;
  final TaskFrequency frequency;
  final TaskType type;
  final TaskEvent event;
  final String link;
  final int requiredCount;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? createdAt;
  final bool isCompleted;
  final int completedCount;

  bool get hasProgress => requiredCount > 1;

  double get progress => (completedCount / requiredCount).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [
    id,
    icon,
    title,
    description,
    coins,
    frequency,
    type,
    event,
    link,
    requiredCount,
    isActive,
    startsAt,
    endsAt,
    createdAt,
    isCompleted,
    completedCount,
  ];

  static TaskFrequency _parseFrequency(dynamic value) {
    return switch ('${value ?? ''}'.trim().toUpperCase()) {
      'ONCE' => TaskFrequency.once,
      'DAILY' => TaskFrequency.daily,
      'WEEKLY' => TaskFrequency.weekly,
      'SPECIAL' => TaskFrequency.special,
      _ => TaskFrequency.unknown,
    };
  }

  static TaskType _parseType(dynamic value) {
    return switch ('${value ?? ''}'.trim().toUpperCase()) {
      'AUTO' => TaskType.auto,
      'MANUAL' => TaskType.manual,
      _ => TaskType.unknown,
    };
  }

  static TaskEvent _parseEvent(dynamic value) {
    return switch ('${value ?? ''}'.trim().toUpperCase()) {
      'GET_CERTIFICATE' => TaskEvent.getCertificate,
      'COURSE_COMPLETE' => TaskEvent.courseComplete,
      'PROFILE_FILL' => TaskEvent.profileFill,
      'WRITE_COMMIT_TO_COURSE' => TaskEvent.writeCommitToCourse,
      'CREATE_PORTFOLIO' => TaskEvent.createPortfolio,
      _ => TaskEvent.unknown,
    };
  }

  static int _parsePositiveInt(dynamic value, {required int fallback}) {
    final parsed = int.tryParse('${value ?? ''}');
    if (parsed == null || parsed < 1) return fallback;
    return parsed;
  }

  static int _parseNonNegativeInt(dynamic value) {
    final parsed = int.tryParse('${value ?? 0}') ?? 0;
    return parsed < 0 ? 0 : parsed;
  }

  static bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return fallback;
  }
}
