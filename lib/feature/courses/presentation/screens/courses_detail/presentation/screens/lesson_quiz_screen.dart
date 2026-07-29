import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/lesson_quiz_question_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/lesson_quiz_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_quiz_exit_dialog.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_quiz_option_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_launch_context.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_screen_mixin.dart';

class LessonQuizScreen extends StatelessWidget {
  const LessonQuizScreen({
    super.key,
    required this.lessonId,
    this.launchContext,
  });

  final String lessonId;
  final LessonQuizLaunchContext? launchContext;

  @override
  Widget build(BuildContext context) {
    final id = lessonId.trim();
    if (id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return LessonQuizLaunchScope(
      launch: launchContext,
      child: BlocProvider(
        create: (_) =>
            LessonQuizBloc(getIt<LessonQuizRepository>(), lessonId: id)
              ..add(const LessonQuizStarted()),
        child: const LessonQuizView(),
      ),
    );
  }
}

class LessonQuizView extends StatefulWidget {
  const LessonQuizView({super.key});

  @override
  State<LessonQuizView> createState() => _LessonQuizViewState();
}

class _LessonQuizViewState extends State<LessonQuizView>
    with LessonQuizScreenMixin<LessonQuizView> {
  LessonQuizState? _quizPrevState;
  late final PageController _quizPageController;

  @override
  void initState() {
    super.initState();
    _quizPageController = PageController();
  }

  @override
  void dispose() {
    _quizPageController.dispose();
    super.dispose();
  }

  void _syncQuizPageView(LessonQuizState prev, LessonQuizState next) {
    if (next.questions.isEmpty ||
        next.status == LessonQuizUiStatus.previewResult) {
      return;
    }
    if (prev.currentIndex == next.currentIndex) return;
    final i = next.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_quizPageController.hasClients) return;
      if (i < 0 || i >= next.questions.length) return;
      final cur = _quizPageController.page?.round() ?? 0;
      if (cur != i) {
        _quizPageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

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
          lessonQuizStateListener(context, prev, state);
          _syncQuizPageView(prev, state);
          _quizPrevState = state;
        },
        builder: (context, state) {
          if (state.questions.isEmpty) {
            return AppPageScaffold(
              title: context.l10n.lessonQuizTitle,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == LessonQuizUiStatus.previewResult) {
            return AppPageScaffold(
              title: context.l10n.lessonQuizTitle,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == LessonQuizUiStatus.loading) {
            return AppPageScaffold(
              title: context.l10n.lessonQuizTitle,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final q = state.currentQuestion;
          if (q == null) {
            return AppPageScaffold(
              title: context.l10n.lessonQuizTitle,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final busy = state.status == LessonQuizUiStatus.checking;
          final total = state.questions.length;
          final idx = state.currentIndex;
          final revealed = state.isCurrentRevealed;
          final selected = state.selectedByQuizId[q.id] ?? {};
          final isMulti = q.type == LessonQuizQuestionType.multipleChoice;
          final doneRatio = total == 0
              ? 0.0
              : (idx + (revealed ? 1 : 0)) / total;
          final pct = (doneRatio * 100).clamp(0, 100).round();
          final primaryEnabled =
              isMulti &&
              !busy &&
              state.status == LessonQuizUiStatus.ready &&
              !revealed &&
              selected.isNotEmpty;
          final bottomInset = 16 + MediaQuery.paddingOf(context).bottom;
          final listBottomPad = isMulti ? 100.0 : 24.0;

          return AppPageScaffold(
            title: '',
            backgroundColor: context.theme.scaffoldBackgroundColor,
            centerTitle: true,
            titleWidget: Text(
              context.l10n.lessonQuizTitle,
              style: context.textTheme.bodyLargeBold,
            ),
            backButton: IconButton(
              icon: const Icon(LucideIcons.x),
              onPressed: _confirmPop,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.radius5xl,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedQuizCountdown() ?? '--:--',
                          style: context.textTheme.bodySmallSemibold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                                Text(
                                  context.l10n.lessonQuizQuestionLabel,
                                  style: context.textTheme.bodyXSmallBold
                                      .copyWith(
                                        color: AppColors.primary,
                                        letterSpacing: 0.6,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.lessonQuizQuestionProgress(
                                    idx + 1,
                                    total,
                                  ),
                                  style: context.textTheme.bodyLargeBold
                                      .copyWith(color: context.appColors.text),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.l10n.lessonQuizPercentComplete(pct),
                            style: context.textTheme.bodyXSmallRegular.copyWith(
                              color: context.appColors.grey,
                            ),
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
                  child: PageView.builder(
                    controller: _quizPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: total,
                    itemBuilder: (context, pageIndex) {
                      final question = state.questions[pageIndex];
                      final isActive = pageIndex == idx;
                      final qRevealed = state.revealedByQuizId.containsKey(
                        question.id,
                      );
                      final qCorrect = state.revealedByQuizId[question.id];
                      final qSelected =
                          state.selectedByQuizId[question.id] ?? {};
                      final imageUrl = _quizQuestionImageUrl(question);
                      final optionEnabled = isActive && !busy && !qRevealed;

                      return ListView(
                        padding: EdgeInsets.fromLTRB(20, 18, 20, listBottomPad),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.appColors.onContainer,
                              borderRadius: AppRadius.radius2xl,
                              border: Border.all(
                                color: context.appColors.stroke,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: context.appColors.shadow.withValues(
                                    alpha: 0.06,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: AppRadius.radius5xl,
                                      ),
                                      child: Text(
                                        question.type ==
                                                LessonQuizQuestionType
                                                    .multipleChoice
                                            ? context
                                                  .l10n
                                                  .lessonQuizTypeMultiple
                                            : context.l10n.lessonQuizTypeSingle,
                                        style: context.textTheme.bodyXSmallBold
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      LucideIcons.lightbulb,
                                      size: 20,
                                      color: context.appColors.grey.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ],
                                ),
                                if (imageUrl != null) ...[
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: AppRadius.radiusXl,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: AppCachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Text(
                                  question.question,
                                  style: context.textTheme.bodyMediumBold
                                      .copyWith(
                                        color: context.appColors.text,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...question.options.asMap().entries.map((e) {
                            final i = e.key;
                            final opt = e.value;
                            final letter = String.fromCharCode(65 + i);
                            final sel = qSelected.contains(opt.id);
                            bool? wasCorrect;
                            if (qRevealed && sel) {
                              wasCorrect = qCorrect;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: LessonQuizOptionCard(
                                letter: letter,
                                label: opt.value,
                                selected: sel,
                                revealed: qRevealed,
                                wasCorrectChoice: wasCorrect,
                                enabled: optionEnabled,
                                onTap: () {
                                  final bloc = context.read<LessonQuizBloc>();
                                  if (question.type ==
                                      LessonQuizQuestionType.singleChoice) {
                                    bloc.add(
                                      LessonQuizSingleOptionChosen(opt.id),
                                    );
                                  } else {
                                    bloc.add(LessonQuizOptionToggled(opt.id));
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
                if (isMulti && !revealed)
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset),
                    child: PrimaryButton.elevated(
                      label: context.l10n.lessonQuizMark,
                      onPressed: primaryEnabled
                          ? () => context.read<LessonQuizBloc>().add(
                              const LessonQuizPrimaryPressed(),
                            )
                          : null,
                      isLoading: busy,
                      expand: true,
                      applyTabletMaxWidth: false,
                      height: 54,
                      shape: AppPrimaryButtonShape.roundedRectangle,
                      borderRadius: AppRadius.radius3xl,
                      backgroundColor: AppColors.primary,
                      textStyle: context.textTheme.bodyLargeBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  )
                else if (isMulti && revealed)
                  SizedBox(height: bottomInset)
                else if (!isMulti && busy)
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset),
                    child: const SizedBox(
                      height: 54,
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(height: bottomInset),
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
