import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';

class LeaderboardApiDatasource implements LeaderboardDatasource {
  const LeaderboardApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions() async {
    final response = await _dio.get<dynamic>(
      '${Apis.leaderboard}/courses',
    );
    final list = _asList(response.data);
    return list.whereType<Map>().map((item) {
      final map = item.map((key, value) => MapEntry(key.toString(), value));
      return LeaderboardCourseOptionModel(
        id: (map['id'] ?? '').toString(),
        name: (map['name'] ?? '').toString(),
      );
    }).toList(growable: false);
  }

  @override
  Future<List<LeaderboardUserModel>> getLeaderboard({
    required LeaderboardTimeframe timeframe,
    String? courseId,
  }) async {
    final response = await _dio.get<dynamic>(
      Apis.leaderboard,
      queryParameters: <String, dynamic>{
        'timeframe': timeframe.name,
        if ((courseId ?? '').isNotEmpty) 'course_id': courseId,
      },
    );
    final list = _asList(response.data);
    return list.whereType<Map>().map((item) {
      final map = item.map((key, value) => MapEntry(key.toString(), value));
      return LeaderboardUserModel(
        id: (map['id'] ?? '').toString(),
        userCode: (map['user_code'] ?? map['userCode'] ?? '').toString(),
        fullName: (map['full_name'] ?? map['fullName'] ?? '').toString(),
        avatarUrl: (map['avatar_url'] ?? map['avatarUrl'] ?? '').toString(),
        rank: (map['rank'] ?? 0).toString().parseIntSafe(),
        score: (map['score'] ?? 0).toString().parseIntSafe(),
        courseName: (map['course_name'] ?? map['courseName'] ?? '').toString(),
        finishedCoursesCount:
            (map['finished_courses_count'] ?? map['finishedCoursesCount'] ?? 0)
                .toString()
                .parseIntSafe(),
        certificatesCount:
            (map['certificates_count'] ?? map['certificatesCount'] ?? 0)
                .toString()
                .parseIntSafe(),
        followerCount:
            (map['follower_count'] ?? map['followerCount'] ?? '0').toString(),
        rating: (map['rating'] ?? 0).toString().parseDoubleSafe(),
      );
    }).toList(growable: false);
  }

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    throw const FormatException('Leaderboard response should be a list');
  }
}

extension on String {
  int parseIntSafe() => int.tryParse(this) ?? 0;
  double parseDoubleSafe() => double.tryParse(this) ?? 0;
}
