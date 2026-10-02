import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/daily_coin_feature.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/core/network/daily_streak_daily_fetch_service.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/data/daily_coin_calendar_day.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/bloc/daily_coin_bloc.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/components/daily_coin_sheet_content.dart';

Future<void> _markDailyCoinSheetEngagedToday() async {
  final prefs = getIt<SharedPreferences>();
  await prefs.setString(
    StorageKey.dailyCoinSheetEngagedDayV1.name,
    DailyCoinCalendarDay.todayLocal(),
  );
}

Widget _dailyCoinSheetPage(
  BuildContext context, {
  DailyStreakModel? initialStreak,
}) {
  return BlocProvider(
    create: (_) {
      final bloc = getIt<DailyCoinBloc>();
      bloc.add(
        initialStreak == null
            ? const DailyCoinStarted()
            : DailyCoinSeeded(initialStreak),
      );
      return bloc;
    },
    child: BlocListener<DailyCoinBloc, DailyCoinState>(
      listenWhen: (previous, current) {
        final claimSucceeded =
            previous.status == DailyCoinStatus.claiming &&
            current.status == DailyCoinStatus.success;
        final claimFailed =
            current.status == DailyCoinStatus.failure &&
            current.message == 'claim_failed' &&
            current.streak != null;
        return claimSucceeded || claimFailed;
      },
      listener: (context, state) {
        if (state.status == DailyCoinStatus.success) {
          final streak = state.streak;
          if (streak != null &&
              getIt.isRegistered<DailyStreakDailyFetchService>()) {
            unawaited(
              getIt<DailyStreakDailyFetchService>().saveSnapshot(streak),
            );
          }
          Navigator.of(context).pop();
          return;
        }
        AppToast.error(context, message: context.l10n.dailyCoinClaimError);
      },
      child: AppBottomSheetContainer(
        showHandle: true,
        headerGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.appColors.primary.withValues(alpha: 0.22),
            Colors.transparent,
          ],
        ),
        // padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: const DailyCoinSheetContent(),
      ),
    ),
  );
}

Future<void> _openDailyCoinBottomSheet(
  BuildContext context, {
  DailyStreakModel? initialStreak,
}) {
  return showAppBottomSheet<void>(
    context,
    child: _dailyCoinSheetPage(context, initialStreak: initialStreak),
  );
}

/// Qo‘lda ochish (Tangalar bloki): kun uchun «bir marta» auto-sheet bilan ziddiyat yo‘q.
Future<void> showDailyCoinBottomSheet(BuildContext context) async {
  if (!kDailyCoinFeatureEnabled) return;
  await _markDailyCoinSheetEngagedToday();
  if (!context.mounted) return;
  await _openDailyCoinBottomSheet(context);
}

/// Bosh sahifa: typed snapshot bo'yicha **tangani hali olmagan** bo'lsa sheet
/// ochadi. `false` — olingan yoki sheet bugun allaqachon ochilgan.
Future<bool> tryAutopresentDailyCoinSheetFromHomePrefetch(
  BuildContext context,
  DailyStreakModel streak,
) async {
  if (!kDailyCoinFeatureEnabled) return false;
  final prefs = getIt<SharedPreferences>();
  final today = DailyCoinCalendarDay.todayLocal();
  if (prefs.getString(StorageKey.dailyCoinSheetEngagedDayV1.name) == today) {
    return false;
  }

  if (streak.isClaimed) return false;

  await _markDailyCoinSheetEngagedToday();
  if (!context.mounted) return false;
  await _openDailyCoinBottomSheet(context, initialStreak: streak);
  return true;
}
