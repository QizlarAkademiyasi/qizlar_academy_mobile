import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_bottom_action.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/course_submit_review_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/components/course_submit_review_course_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/components/course_submit_review_star_picker.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_screen_mixin.dart';

class CourseSubmitReviewScreen extends StatelessWidget {
  const CourseSubmitReviewScreen({super.key, required this.args});

  final CourseSubmitReviewArgs args;

  @override
  Widget build(BuildContext context) {
    final id = args.courseId.trim();
    if (id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return BlocProvider(
      create: (_) =>
          CourseSubmitReviewBloc(getIt<CoursesRepository>(), courseId: id),
      child: CourseSubmitReviewView(args: args),
    );
  }
}

class CourseSubmitReviewView extends StatefulWidget {
  const CourseSubmitReviewView({super.key, required this.args});

  final CourseSubmitReviewArgs args;

  @override
  State<CourseSubmitReviewView> createState() => _CourseSubmitReviewViewState();
}

class _CourseSubmitReviewViewState extends State<CourseSubmitReviewView>
    with CourseSubmitReviewScreenMixin<CourseSubmitReviewView> {
  @override
  CourseSubmitReviewArgs get submitReviewArgs => widget.args;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final l10n = context.l10n;

    return AppPageScaffold(
      title: l10n.courseSubmitReviewTitle,
      onBackTap: () => context.pop(),
      backgroundColor: context.appColors.background,
      body: BlocConsumer<CourseSubmitReviewBloc, CourseSubmitReviewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: submitReviewBlocListener,
        builder: (context, state) {
          final submitting =
              state.status == CourseSubmitReviewStatus.submitting;
          final commentFilled = submitReviewCommentController.text
              .trim()
              .isNotEmpty;
          final canSubmit = submitReviewRating >= 1 && commentFilled;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CourseSubmitReviewCourseCard(args: widget.args),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: AppPadding.paddingLg,
                        decoration: BoxDecoration(
                          color: context.appColors.onContainer,
                          borderRadius: AppRadius.radius2xl,
                          border: Border.all(color: context.appColors.stroke),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.courseSubmitReviewRateTitle,
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyLargeSemibold
                                  .copyWith(color: context.appColors.text),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.courseSubmitReviewRateSubtitle,
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyMediumRegular
                                  .copyWith(
                                    color: context.appColors.grey,
                                    height: 1.45,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            CourseSubmitReviewStarPicker(
                              rating: submitReviewRating,
                              onChanged: onSubmitReviewRatingChanged,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.courseSubmitReviewYourCommentLabel,
                        style: context.textTheme.bodySmallRegular.copyWith(
                          color: context.appColors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: context.appColors.onContainer,
                          borderRadius: AppRadius.radius2xl,
                          border: Border.all(color: context.appColors.stroke),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: submitReviewCommentController,
                              maxLines: 6,
                              maxLength: CourseSubmitReviewScreenMixin
                                  .maxCommentLength,
                              buildCounter:
                                  (
                                    _, {
                                    required currentLength,
                                    required isFocused,
                                    maxLength,
                                  }) => const SizedBox.shrink(),
                              onChanged: (_) => setState(() {}),
                              style: context.textTheme.bodyMediumRegular
                                  .copyWith(color: context.appColors.text),
                              decoration: InputDecoration(
                                hintText: l10n.courseSubmitReviewCommentHint,
                                hintStyle: context.textTheme.bodyMediumRegular
                                    .copyWith(
                                      color: context.appColors.grey.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                l10n.courseSubmitReviewCharCount(
                                  submitReviewCommentController.text.length
                                      .clamp(
                                        0,
                                        CourseSubmitReviewScreenMixin
                                            .maxCommentLength,
                                      ),
                                  CourseSubmitReviewScreenMixin
                                      .maxCommentLength,
                                ),
                                style: context.textTheme.bodySmallRegular
                                    .copyWith(color: context.appColors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12 + bottom),
                child: CourseBottomAction(
                  label: l10n.courseSubmitReviewSubmit,
                  showLeadingIcon: false,
                  enabled: canSubmit,
                  isLoading: submitting,
                  onTap: () => onSubmitReviewPressed(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
