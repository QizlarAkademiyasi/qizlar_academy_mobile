import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/daily_coin_feature.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/data/daily_coin_calendar_day.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';

/// `/activity/streak` ni kalend kuniga **bir marta** sinxron qilish (sessiya tokeniga bog‘liq).
///
/// Streak sheet ochilganda ham xuddi shu repository chaqiriladi — backend uchun kuniga
/// bir martalik GET ko‘pincha shu yerda to‘lanadi; sheet faqat UI uchun qayta yuklaydi.
final class DailyStreakDailyFetchService {
  DailyStreakDailyFetchService(this._prefs, this._repository, this._authSessionCubit);

  final SharedPreferences _prefs;
  final DailyCoinRepository _repository;
  final AuthSessionCubit _authSessionCubit;

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

  /// Agar bugun bu sessiya uchun allaqachon muvaffaqiyatli prefetch bo‘lgan bo‘lsa — tarmoq yo‘q.
  Future<void> ensureFetchedOnceToday() async {
    if (!kDailyCoinFeatureEnabled) return;
    if (!_eligible) return;

    final today = DailyCoinCalendarDay.todayLocal();
    final sig = _accessSig();
    if (_prefs.getString(_keyCalendarDay) == today && _prefs.getString(_keyAccessSig) == sig) {
      return;
    }

    try {
      final streak = await _repository.fetchStreak();
      await _prefs.setString(_keyCalendarDay, today);
      await _prefs.setString(_keyAccessSig, sig);
      await _prefs.setString(
        StorageKey.dailyStreakSnapshotV1.name,
        jsonEncode(<String, Object?>{
          'calendarDay': today,
          'streakCount': streak.streakCount,
          'isClaimed': streak.isClaimed,
        }),
      );
    } catch (e, st) {
      AppLogger.w('Daily streak prefetch (GET /activity/streak) failed', error: e, stackTrace: st);
    }
  }
}
