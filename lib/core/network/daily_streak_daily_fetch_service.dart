import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/daily_coin_feature.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/data/daily_coin_calendar_day.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';

/// `/activity/streak` ni kalend kuniga **bir marta** sinxron qiladi va typed
/// snapshotni Daily Coin sheetga uzatadi.
final class DailyStreakDailyFetchService {
  DailyStreakDailyFetchService(
    this._prefs,
    this._repository,
    this._authSessionCubit,
  );

  final SharedPreferences _prefs;
  final DailyCoinRepository _repository;
  final AuthSessionCubit _authSessionCubit;

  Future<DailyStreakModel?>? _fetchInFlight;
  String? _fetchInFlightKey;

  static const String _keyCalendarDay = 'daily_streak_prefetch_calendar_day_v1';
  static const String _keyAccessSig = 'daily_streak_prefetch_access_sig_v1';

  bool get _eligible {
    final s = _authSessionCubit.state;
    return s.isRegistered && (s.accessToken ?? '').trim().isNotEmpty;
  }

  /// Token yangilanishi bilan bir xil foydalanuvchi kun ichida qayta GET ketishi mumkin.
  String _accessSig() {
    final t = _authSessionCubit.state.accessToken ?? '';
    return '${t.hashCode}';
  }

  /// Bugungi snapshot mavjud bo'lsa qaytaradi, aks holda faqat bir marta GET qiladi.
  Future<DailyStreakModel?> ensureFetchedOnceToday() async {
    if (!kDailyCoinFeatureEnabled) return null;
    if (!_eligible) return null;

    final today = DailyCoinCalendarDay.todayLocal();
    final sig = _accessSig();
    if (_prefs.getString(_keyCalendarDay) == today &&
        _prefs.getString(_keyAccessSig) == sig) {
      final cached = _readSnapshot(today);
      if (cached != null) return cached;
    }

    final requestKey = '$today::$sig';
    final current = _fetchInFlight;
    if (current != null && _fetchInFlightKey == requestKey) return current;

    final future = _fetchAndSave();
    _fetchInFlight = future;
    _fetchInFlightKey = requestKey;
    return future.whenComplete(() {
      if (identical(_fetchInFlight, future)) {
        _fetchInFlight = null;
        _fetchInFlightKey = null;
      }
    });
  }

  Future<DailyStreakModel?> _fetchAndSave() async {
    try {
      final streak = await _repository.fetchStreak();
      await saveSnapshot(streak);
      return streak;
    } catch (e, st) {
      AppLogger.w(
        'Daily streak prefetch (GET /activity/streak) failed',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<void> saveSnapshot(DailyStreakModel streak) async {
    if (!_eligible) return;
    final today = DailyCoinCalendarDay.todayLocal();
    await _prefs.setString(_keyCalendarDay, today);
    await _prefs.setString(_keyAccessSig, _accessSig());
    await _prefs.setString(
      StorageKey.dailyStreakSnapshotV1.name,
      jsonEncode(<String, Object?>{
        'calendarDay': today,
        'streakCount': streak.streakCount,
        'isClaimed': streak.isClaimed,
      }),
    );
  }

  DailyStreakModel? _readSnapshot(String today) {
    final raw = _prefs.getString(StorageKey.dailyStreakSnapshotV1.name);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final map = decoded.map((key, value) => MapEntry(key.toString(), value));
      if (map['calendarDay'] != today) return null;
      final count = int.tryParse('${map['streakCount']}');
      if (count == null) return null;
      final claimedRaw = map['isClaimed'];
      final claimed = claimedRaw is bool
          ? claimedRaw
          : '$claimedRaw'.toLowerCase() == 'true';
      return DailyStreakModel(
        streakCount: count.clamp(1, 10),
        isClaimed: claimed,
      );
    } catch (_) {
      return null;
    }
  }
}
