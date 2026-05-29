import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_bar_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/repository/my_activity_repository.dart';

class MyActivityApiDatasource {
  const MyActivityApiDatasource(this._dio);

  final Dio _dio;

  Future<ActivityStatsModel> fetchStats(MyActivityStatsScope scope) async {
    final response = await _dio.get<dynamic>(
      UserApis.activityStats(type: scope.queryValue),
    );
    final data = _unwrapDataAsMap(response.data);
    final rawBars = _asList(data['bars']);
    final bars = rawBars.map(_mapBar).toList(growable: false);

    return ActivityStatsModel(
      bars: bars,
      totalDurationMinutes: _parseInt(data['totalDuration']),
      averageDurationMinutes: _parseInt(data['averageDuration']),
      dailyRecordMinutes: _parseInt(data['dailyRecord']),
      completedCourses: _parseInt(data['completedCourses']),
    );
  }

  ActivityBarModel _mapBar(Map<String, dynamic> item) {
    return ActivityBarModel(
      label: (item['label'] ?? '').toString(),
      durationMinutes: _parseInt(item['duration']),
      isToday: _parseBool(item['isToday']),
    );
  }

  Map<String, dynamic> _unwrapDataAsMap(dynamic raw) {
    final envelope = _asMap(raw);
    return _asMap(envelope['data']);
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_asMap).toList(growable: false);
  }

  int _parseInt(dynamic value) => int.tryParse('${value ?? 0}') ?? 0;

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      return lower == 'true' || lower == '1';
    }
    if (value is num) return value != 0;
    return false;
  }
}
