import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';

void main() {
  group('TaskItemModel.fromJson', () {
    test('maps client progress fields and enums', () {
      final task = TaskItemModel.fromJson(const <String, dynamic>{
        'id': 'task-1',
        'icon': 'target',
        'title': '4 ta sertifikat ol',
        'description': 'Istalgan 4 ta kursni tugating',
        'coins': 500,
        'frequency': 'ONCE',
        'type': 'AUTO',
        'event': 'GET_CERTIFICATE',
        'count': 4,
        'isActive': true,
        'isCompleted': false,
        'completedCount': 2,
      });

      expect(task.frequency, TaskFrequency.once);
      expect(task.type, TaskType.auto);
      expect(task.event, TaskEvent.getCertificate);
      expect(task.requiredCount, 4);
      expect(task.completedCount, 2);
      expect(task.progress, 0.5);
      expect(task.isCompleted, isFalse);
    });

    test('defaults null count to one and derives completion defensively', () {
      final task = TaskItemModel.fromJson(const <String, dynamic>{
        'id': 'task-2',
        'frequency': 'DAILY',
        'type': 'MANUAL',
        'event': 'PROFILE_FILL',
        'count': null,
        'completedCount': 1,
      });

      expect(task.requiredCount, 1);
      expect(task.isCompleted, isTrue);
      expect(task.progress, 1);
    });
  });
}
