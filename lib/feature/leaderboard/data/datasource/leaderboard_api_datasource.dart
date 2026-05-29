import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/enum/user_type.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';

class LeaderboardApiDatasource implements LeaderboardDatasource {
  const LeaderboardApiDatasource(this._dio);

  final Dio _dio;

  Future<List<LeaderboardCourseOptionModel>> getCourseOptionsByUserType({required UserType userType}) async {
    final response = await _dio.get<dynamic>(
      userType == UserType.user ? UserApis.coursesClient : AnonymousApis.coursesClientPublic,
      queryParameters: const <String, dynamic>{'pageNumber': 1, 'pageSize': 100},
    );

    final items = _extractDataList(response.data);
    return items
        .whereType<Map>()
        .map((item) {
          final map = item.map((key, value) => MapEntry(key.toString(), value));
          return LeaderboardCourseOptionModel(id: (map['id'] ?? '').toString(), name: (map['name'] ?? '').toString());
        })
        .toList(growable: false);
  }

  @override
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions() async {
    // Legacy method kept for interface compatibility.
    // Real selection is performed via getCourseOptionsByUserType from repository.
    return getCourseOptionsByUserType(userType: UserType.guest);
  }

  @override
  Future<List<LeaderboardUserModel>> getLeaderboard({required LeaderboardTimeframe timeframe, String? courseId}) async {
    return getLeaderboardByUserType(userType: UserType.guest, timeframe: timeframe, courseId: courseId);
  }

  Future<List<LeaderboardUserModel>> getLeaderboardByUserType({required UserType userType, required LeaderboardTimeframe timeframe, required String? courseId}) async {
    final response = await _dio.get<dynamic>(
      userType == UserType.user ? UserApis.coursesLeaderboard : AnonymousApis.coursesLeaderboardPublic,
      queryParameters: <String, dynamic>{'period': _mapPeriod(timeframe), if ((courseId ?? '').trim().isNotEmpty) 'courseId': courseId, 'pageNumber': 1, 'pageSize': 100},
    );

    final items = _extractDataList(response.data);
    final parsed = items
        .whereType<Map>()
        .map((item) {
          final map = item.map((key, value) => MapEntry(key.toString(), value));
          return LeaderboardUserModel(
            rank: (map['rank'] ?? 0).toString().parseIntSafe(),
            id: (map['id'] ?? '').toString(),
            firstname: (map['firstname'] ?? '').toString(),
            lastname: (map['lastname'] ?? '').toString(),
            photoUrl: Apis.resolveUrl((map['photo'] ?? '').toString()),
            coins: (map['coins'] ?? 0).toString().parseIntSafe(),
            rating: _parseRating(map['rating']),
            isCurrentUser: (map['isCurrentUser'] ?? false) == true,
          );
        })
        .toList(growable: false);
    return _sortLeaderboardUsers(parsed);
  }

  /// Backend barcha teng natijalarga bir xil `rank` berishi va massiv tartibini
  /// kafolatlamasligi mumkin — podium va ro'yxat uchun yagona tartib.
  List<LeaderboardUserModel> _sortLeaderboardUsers(List<LeaderboardUserModel> items) {
    if (items.length <= 1) return items;
    final copy = List<LeaderboardUserModel>.from(items);
    copy.sort((a, b) {
      final byCoins = b.coins.compareTo(a.coins);
      if (byCoins != 0) return byCoins;
      final byRank = a.rank.compareTo(b.rank);
      if (byRank != 0) return byRank;
      final byName = a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
      if (byName != 0) return byName;
      return a.id.compareTo(b.id);
    });
    return copy;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return <String, dynamic>{};
  }

  List<dynamic> _extractDataList(dynamic responseData) {
    final envelope = _asMap(responseData);
    final data = _asMap(envelope['data']);
    final items = data['data'];
    if (items is List) return items;
    return const [];
  }

  String _mapPeriod(LeaderboardTimeframe timeframe) {
    switch (timeframe) {
      case LeaderboardTimeframe.overall:
        return 'all';
      case LeaderboardTimeframe.weekly:
        return 'weekly';
      case LeaderboardTimeframe.monthly:
        return 'monthly';
    }
  }
}

double _parseRating(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

extension on String {
  int parseIntSafe() => int.tryParse(this) ?? 0;
}
