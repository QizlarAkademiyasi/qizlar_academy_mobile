import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// `true` — testdan chiqish, `false` — qolish.
Future<bool?> showLessonQuizExitDialog(BuildContext context) {
  final l10n = context.l10n;
  return showAppPrimaryConfirmDialog(
    context,
    title: l10n.lessonQuizExitTitle,
    description: l10n.lessonQuizExitBody,
    cancelLabel: l10n.lessonQuizExitStay,
    confirmLabel: l10n.lessonQuizExitLeave,
  );
}
