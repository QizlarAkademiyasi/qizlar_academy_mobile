import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';

class DailyCoinApiDatasource {
  const DailyCoinApiDatasource(this._dio);

  final Dio _dio;

  Future<DailyStreakModel> getStreak() async {
    final response = await _dio.get<dynamic>(UserApis.activityStreak);
    final data = _unwrapDataAsMap(response.data);
    final rawCount = data['streakCount'];
    var count = int.tryParse('$rawCount') ?? 0;
    count = count.clamp(1, 10);
    final claimed = _parseBool(data['isClaimed']);
    return DailyStreakModel(streakCount: count, isClaimed: claimed);
  }

  Future<void> claimStreak() async {
    await _dio.post<dynamic>(UserApis.activityStreakClaim);
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
