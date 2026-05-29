import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/daily_coin_feature.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/data/daily_coin_calendar_day.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/bloc/daily_coin_bloc.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/components/daily_coin_sheet_content.dart';

Future<void> _markDailyCoinSheetEngagedToday() async {
  final prefs = getIt<SharedPreferences>();
  await prefs.setString(
    StorageKey.dailyCoinSheetEngagedDayV1.name,
    DailyCoinCalendarDay.todayLocal(),
  );
}

Widget _dailyCoinSheetPage(BuildContext context) {
  return BlocProvider(
    create: (_) => getIt<DailyCoinBloc>()..add(const DailyCoinStarted()),
    child: BlocListener<DailyCoinBloc, DailyCoinState>(
      listenWhen: (previous, current) =>
          current.status == DailyCoinStatus.failure &&
          current.message == 'claim_failed' &&
          current.streak != null,
      listener: (context, state) {
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: const DailyCoinSheetContent(),
      ),
    ),
  );
}

Future<void> _openDailyCoinBottomSheet(BuildContext context) {
  return showAppBottomSheet<void>(
    context,
    child: _dailyCoinSheetPage(context),
  );
}

/// Qo‘lda ochish (Tangalar bloki): kun uchun «bir marta» auto-sheet bilan ziddiyat yo‘q.
Future<void> showDailyCoinBottomSheet(BuildContext context) async {
  if (!kDailyCoinFeatureEnabled) return;
  await _markDailyCoinSheetEngagedToday();
  if (!context.mounted) return;
  await _openDailyCoinBottomSheet(context);
}

/// Bosh sahifa: prefetch snapshot asosida **tangani hali olmagan** bo‘lsa sheet ochadi.
///
/// Qaytishi: `null` — snapshot yo‘q, birozdan keyin qayta urinish mumkin;
/// `true` — sheet muvaffaqiyatli ochildi; `false` — ochilmadi (olingan, boshqa kun, allaqachon ochilgan).
Future<bool?> tryAutopresentDailyCoinSheetFromHomePrefetch(BuildContext context) async {
  if (!kDailyCoinFeatureEnabled) return false;
  final prefs = getIt<SharedPreferences>();
  final today = DailyCoinCalendarDay.todayLocal();
  if (prefs.getString(StorageKey.dailyCoinSheetEngagedDayV1.name) == today) {
    return false;
  }

  final raw = prefs.getString(StorageKey.dailyStreakSnapshotV1.name);
  if (raw == null) return null;

  Map<String, dynamic> map;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return false;
    map = decoded;
  } catch (_) {
    return false;
  }

  if (map['calendarDay'] != today) return false;

  final claimedRaw = map['isClaimed'];
  final isClaimed = claimedRaw is bool
      ? claimedRaw
      : claimedRaw is String && claimedRaw.toLowerCase() == 'true';

  if (isClaimed) return false;

  await _markDailyCoinSheetEngagedToday();
  if (!context.mounted) return false;
  await _openDailyCoinBottomSheet(context);
  return true;
}
