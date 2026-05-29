import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/course_submit_review_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_args.dart';

mixin CourseSubmitReviewScreenMixin<T extends StatefulWidget> on State<T> {
  static const int maxCommentLength = 500;

  CourseSubmitReviewArgs get submitReviewArgs;

  final TextEditingController submitReviewCommentController = TextEditingController();

  double submitReviewRating = 0;

  @override
  void dispose() {
    submitReviewCommentController.dispose();
    super.dispose();
  }

  void onSubmitReviewRatingChanged(double value) {
    setState(() => submitReviewRating = value);
  }

  void submitReviewBlocListener(BuildContext context, CourseSubmitReviewState state) {
    if (state.status == CourseSubmitReviewStatus.success) {
      submitReviewArgs.onSubmitted?.call(submitReviewRating, submitReviewCommentController.text.trim());
      AppToast.success(context, message: context.l10n.courseSubmitReviewSuccess);
      context.pop(true);
      return;
    }
    if (state.status == CourseSubmitReviewStatus.failure) {
      AppToast.error(context, message: context.l10n.courseSubmitReviewError);
    }
  }

  void onSubmitReviewPressed(BuildContext context) {
    if (submitReviewRating < 1 || submitReviewCommentController.text.trim().isEmpty) {
      return;
    }
    context.read<CourseSubmitReviewBloc>().add(
          CourseSubmitReviewSubmitted(
            rating: submitReviewRating,
            comment: submitReviewCommentController.text.trim(),
          ),
        );
  }
}
