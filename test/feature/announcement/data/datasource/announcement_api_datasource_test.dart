import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/announcement/data/datasource/announcement_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';

void main() {
  final datasource = AnnouncementApiDatasource(Dio());

  test('parses a course announcement response', () {
    final result = datasource.parseNextResponse({
      'statusCode': 200,
      'data': {
        'announcement': {
          'viewId': 'view-1',
          'type': 'COURSE',
          'photo': 'https://cdn.example.com/banner.png',
          'link': null,
          'courseId': 'course-1',
          'courseName': 'Marketolog',
        },
        'hasMore': true,
      },
    });

    expect(result.hasMore, isTrue);
    expect(result.announcement?.viewId, 'view-1');
    expect(result.announcement?.type, AnnouncementType.course);
    expect(result.announcement?.courseId, 'course-1');
    expect(result.announcement?.courseName, 'Marketolog');
    expect(result.announcement?.link, isNull);
  });

  test('parses the terminal empty response', () {
    final result = datasource.parseNextResponse({
      'statusCode': 200,
      'data': {'announcement': null, 'hasMore': false},
    });

    expect(result.announcement, isNull);
    expect(result.hasMore, isFalse);
  });
}
