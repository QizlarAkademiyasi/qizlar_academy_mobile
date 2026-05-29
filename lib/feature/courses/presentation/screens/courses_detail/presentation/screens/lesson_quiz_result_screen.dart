import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/lesson_quiz_already_submitted_exception.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_quiz_exit_dialog.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_result_args.dart';

class LessonQuizResultScreen extends StatefulWidget {
  const LessonQuizResultScreen({super.key, required this.args});

  final LessonQuizResultArgs args;

  @override
  State<LessonQuizResultScreen> createState() => _LessonQuizResultScreenState();
}

class _LessonQuizResultScreenState extends State<LessonQuizResultScreen> {
  bool _submitting = false;

  void _onRetryQuiz() {
    if (mounted) context.pop(LessonQuizResultOutcome.retry);
  }

  Future<void> _onContinue() async {
    final args = widget.args;
    if (!args.pendingSubmit) {
      if (mounted) context.pop(args.result);
      return;
    }

    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final serverResult = await getIt<LessonQuizRepository>().submitLessonQuiz(lessonId: args.lessonId, answers: args.answers);
      getIt<LessonQuizRepository>().clearCacheForLesson(args.lessonId);
      if (mounted) context.pop(serverResult);
    } on LessonQuizAlreadySubmittedException {
      if (mounted) {
        AppToast.info(context, message: context.l10n.lessonQuizAlreadyTaken);
        context.pop(args.result);
      }
    } catch (_) {
      if (mounted) {
        AppToast.error(context, message: context.l10n.lessonQuizErrorSubmit);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.args.result;
    final l10n = context.l10n;
    final total = r.totalCount <= 0 ? 1 : r.totalCount;
    final pct = ((r.correctAnswerCount * 100) / total).round().clamp(0, 100);
    final wrong = (r.totalCount - r.correctAnswerCount).clamp(0, r.totalCount);
    final timeLabel = _formatElapsed(widget.args.elapsed);

    return PopScope(
      canPop: !widget.args.pendingSubmit,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_submitting) return;

        final shouldLeave = await showLessonQuizExitDialog(context);
        if (shouldLeave == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Lottie.asset(r.isFail ? UiKitAssets.lottie.rabbit.cryedRabbit : UiKitAssets.lottie.rabbit.greatRabbit, width: 160, height: 160, fit: BoxFit.contain),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('$pct', style: context.textTheme.heading1.copyWith(color: context.appColors.text)),
                        Text('%', style: context.textTheme.heading1.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    Text(
                      r.isFail ? l10n.lessonQuizResultPoor : l10n.lessonQuizResultGreat,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyXLargeBold.copyWith(color: context.appColors.text),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: context.appColors.onContainer,
                        borderRadius: AppRadius.radius2xl,
                        border: Border.all(color: context.appColors.stroke),
                        boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatColumn(icon: LucideIcons.circleCheck, iconColor: const Color(0xFF22C55E), label: l10n.lessonQuizStatCorrect, value: '${r.correctAnswerCount}'),
                          ),
                          Container(width: 1, height: 52, color: context.appColors.stroke),
                          Expanded(
                            child: _StatColumn(icon: LucideIcons.circleX, iconColor: const Color(0xFFEF4444), label: l10n.lessonQuizStatWrong, value: '$wrong'),
                          ),
                          Container(width: 1, height: 52, color: context.appColors.stroke),
                          Expanded(
                            child: _StatColumn(icon: LucideIcons.clock, iconColor: AppColors.primary, label: l10n.lessonQuizStatTime, value: timeLabel),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    const Spacer(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (r.isFail) ...[
                      PrimaryButton.outlined(
                        label: l10n.lessonQuizRetry,
                        onPressed: _onRetryQuiz,
                        isEnabled: !_submitting,
                        expand: true,
                        applyTabletMaxWidth: false,
                        height: 54,
                        shape: AppPrimaryButtonShape.roundedRectangle,
                        borderRadius: AppRadius.radius3xl,
                        foregroundColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        textStyle: context.textTheme.bodyLargeBold.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 12),
                    ],
                    PrimaryButton.elevated(
                      label: l10n.lessonQuizContinue,
                      onPressed: _onContinue,
                      isLoading: _submitting,
                      expand: true,
                      applyTabletMaxWidth: false,
                      height: 54,
                      shape: AppPrimaryButtonShape.roundedRectangle,
                      borderRadius: AppRadius.radius3xl,
                      textStyle: context.textTheme.bodyLargeBold.copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.icon, required this.iconColor, required this.label, required this.value});

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: iconColor),
        const SizedBox(height: 6),
        Text(label, style: context.textTheme.bodyXSmallSemibold.copyWith(color: iconColor)),
        const SizedBox(height: 4),
        Text(value, style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text)),
      ],
    );
  }
}

String _formatElapsed(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds.remainder(60);
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
