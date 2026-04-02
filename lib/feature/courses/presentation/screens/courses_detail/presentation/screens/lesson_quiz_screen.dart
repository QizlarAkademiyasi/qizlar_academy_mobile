import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/lesson_quiz_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_quiz_exit_dialog.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_quiz_option_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_screen_mixin.dart';

class LessonQuizScreen extends StatelessWidget {
  const LessonQuizScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final id = lessonId.trim();
    if (id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return BlocProvider(
      create: (_) => LessonQuizBloc(getIt<LessonQuizRepository>(), lessonId: id)..add(const LessonQuizStarted()),
      child: const LessonQuizView(),
    );
  }
}

class LessonQuizView extends StatefulWidget {
  const LessonQuizView({super.key});

  @override
  State<LessonQuizView> createState() => _LessonQuizViewState();
}

class _LessonQuizViewState extends State<LessonQuizView> with LessonQuizScreenMixin<LessonQuizView> {
  LessonQuizState? _quizPrevState;

  Future<void> _confirmPop() async {
    final leave = await showLessonQuizExitDialog(context);
    if (leave == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _confirmPop();
      },
      child: BlocConsumer<LessonQuizBloc, LessonQuizState>(
        listener: (context, state) {
          final prev = _quizPrevState ?? state;
          _quizPrevState = state;
          lessonQuizStateListener(context, prev, state);
        },
        builder: (context, state) {
          if (state.questions.isEmpty) {
            return Scaffold(
              backgroundColor: context.theme.scaffoldBackgroundColor,
              appBar: AppBar(title: Text(context.l10n.lessonQuizTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == LessonQuizUiStatus.previewResult) {
            return Scaffold(
              backgroundColor: context.theme.scaffoldBackgroundColor,
              appBar: AppBar(title: Text(context.l10n.lessonQuizTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final q = state.currentQuestion;
          if (q == null) {
            return Scaffold(
              appBar: AppBar(title: Text(context.l10n.lessonQuizTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final busy = state.status == LessonQuizUiStatus.checking;
          final total = state.questions.length;
          final idx = state.currentIndex;
          final revealed = state.isCurrentRevealed;
          final correct = state.currentRevealCorrect;
          final selected = state.selectedByQuizId[q.id] ?? {};
          final doneRatio = total == 0 ? 0.0 : (idx + (revealed ? 1 : 0)) / total;
          final pct = (doneRatio * 100).clamp(0, 100).round();
          final imageUrl = _quizQuestionImageUrl(q);
          final primaryEnabled = !busy && state.status == LessonQuizUiStatus.ready && (revealed || selected.isNotEmpty);
          final isLast = idx >= total - 1;

          String primaryLabel;
          if (!revealed) {
            primaryLabel = context.l10n.lessonQuizMark;
          } else if (isLast) {
            primaryLabel = context.l10n.lessonQuizFinish;
          } else {
            primaryLabel = context.l10n.lessonQuizNext;
          }

          return Scaffold(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text(context.l10n.lessonQuizTitle, style: context.textTheme.bodyLargeBold),
              leading: IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: _confirmPop,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: AppRadius.radius5xl,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.clock, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            formattedQuizCountdown() ?? '--:--',
                            style: context.textTheme.bodySmallSemibold.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.l10n.lessonQuizQuestionLabel, style: context.textTheme.bodyXSmallBold.copyWith(color: AppColors.primary, letterSpacing: 0.6)),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.lessonQuizQuestionProgress(idx + 1, total),
                                  style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.l10n.lessonQuizPercentComplete(pct),
                            style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: AppRadius.radius5xl,
                        child: LinearProgressIndicator(
                          value: doneRatio.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: context.appColors.stroke,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.appColors.onContainer,
                          borderRadius: AppRadius.radius2xl,
                          border: Border.all(color: context.appColors.stroke),
                          boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.radius5xl),
                                  child: Text(
                                    q.type == LessonQuizQuestionType.multipleChoice ? context.l10n.lessonQuizTypeMultiple : context.l10n.lessonQuizTypeSingle,
                                    style: context.textTheme.bodyXSmallBold.copyWith(color: AppColors.white),
                                  ),
                                ),
                                const Spacer(),
                                Icon(LucideIcons.lightbulb, size: 20, color: context.appColors.grey.withValues(alpha: 0.45)),
                              ],
                            ),
                            if (imageUrl != null) ...[
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: AppRadius.radiusXl,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: AppCachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(q.question, style: context.textTheme.bodyMediumBold.copyWith(color: context.appColors.text, height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...q.options.asMap().entries.map((e) {
                        final i = e.key;
                        final opt = e.value;
                        final letter = String.fromCharCode(65 + i);
                        final sel = selected.contains(opt.id);
                        bool? wasCorrect;
                        if (revealed && sel) {
                          wasCorrect = correct;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: LessonQuizOptionCard(
                            letter: letter,
                            label: opt.value,
                            selected: sel,
                            revealed: revealed,
                            wasCorrectChoice: wasCorrect,
                            onTap: () => context.read<LessonQuizBloc>().add(LessonQuizOptionToggled(opt.id)),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + MediaQuery.paddingOf(context).bottom),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.radius3xl),
                      ),
                      onPressed: primaryEnabled ? () => context.read<LessonQuizBloc>().add(const LessonQuizPrimaryPressed()) : null,
                      child: busy
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                          : Text(primaryLabel, style: context.textTheme.bodyLargeBold.copyWith(color: AppColors.white)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String? _quizQuestionImageUrl(LessonQuizQuestionModel q) {
  if (q.mediaType != LessonQuizMediaType.image) return null;
  for (final o in q.options) {
    final link = o.link.trim();
    if (link.isNotEmpty) return link;
  }
  return null;
}
