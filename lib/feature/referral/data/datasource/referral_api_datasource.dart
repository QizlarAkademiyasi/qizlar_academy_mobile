import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_code_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_page_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_pagination_model.dart';

abstract interface class ReferralRemoteDatasource {
  Future<void> useReferralCode({required String code});
  Future<ReferralCodeModel> fetchMyReferralCode();
  Future<ReferralLeaderboardPageModel> fetchLeaderboard({
    required int pageNumber,
    required int pageSize,
  });
}

class ReferralApiDatasource implements ReferralRemoteDatasource {
  const ReferralApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<void> useReferralCode({required String code}) async {
    await _dio.post<dynamic>(
      UserApis.referralUse,
      data: <String, dynamic>{'code': code},
    );
  }

  @override
  Future<ReferralCodeModel> fetchMyReferralCode() async {
    final response = await _dio.get<dynamic>(UserApis.referralCode);
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data'], logOnInvalidType: false);
    return ReferralCodeModel(
      referralCode: (data['referralCode'] ?? '').toString(),
      referralLink: (data['referralLink'] ?? '').toString(),
    );
  }

  @override
  Future<ReferralLeaderboardPageModel> fetchLeaderboard({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      UserApis.referralLeaderboard,
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
      options: Options(receiveTimeout: const Duration(seconds: 45)),
    );
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data'], logOnInvalidType: false);
    final listRaw = _asList(data['data']);
    final items = listRaw.map(_mapUser).toList(growable: false);

    final meta = _asMapOrNull(data['meta']);
    final paginationRaw = _asMap(meta?['pagination'], logOnInvalidType: false);
    final pagination = ReferralPaginationModel(
      pageNumber: _parseInt(paginationRaw['pageNumber'], fallback: pageNumber),
      pageSize: _parseInt(paginationRaw['pageSize'], fallback: pageSize),
      count: _parseInt(paginationRaw['count']),
      pageCount: _parseInt(paginationRaw['pageCount'], fallback: 1),
    );
    final currentUserRaw = _asMapOrNull(meta?['currentUser']);

    return ReferralLeaderboardPageModel(
      items: items,
      pagination: pagination,
      currentUser: currentUserRaw == null ? null : _mapUser(currentUserRaw),
    );
  }

  ReferralLeaderboardUserModel _mapUser(Map<String, dynamic> map) {
    final avatarRaw =
        (map['photo'] ??
        map['avatar'] ??
        map['image'] ??
        map['profilePhoto'] ??
        map['photoUrl']);
    final avatarUrl = avatarRaw?.toString().trim() ?? '';
    return ReferralLeaderboardUserModel(
      rank: _parseInt(map['rank']),
      userId: (map['userId'] ?? '').toString(),
      firstname: (map['firstname'] ?? '').toString(),
      lastname: (map['lastname'] ?? '').toString(),
      referralCode: (map['referralCode'] ?? '').toString(),
      certificatesEarned: _parseInt(map['certificatesEarned']),
      badge: _parseInt(map['badge']),
      isCurrentUser: map['isCurrentUser'] == true,
      photoUrl: avatarUrl.isEmpty ? null : Apis.resolveUrl(avatarUrl),
    );
  }

  Map<String, dynamic> _asMap(dynamic value, {bool logOnInvalidType = true}) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
    if (value == null) return <String, dynamic>{};
    if (logOnInvalidType) {
      AppLogger.w(
        'ReferralApiDatasource: expected map, got ${value.runtimeType}',
      );
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic>? _asMapOrNull(dynamic value) {
    final map = _asMap(value, logOnInvalidType: false);
    return map.isEmpty ? null : map;
  }

  List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((item) => _asMap(item, logOnInvalidType: false))
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    final parsed = int.tryParse('${value ?? fallback}');
    return parsed ?? fallback;
  }
}
