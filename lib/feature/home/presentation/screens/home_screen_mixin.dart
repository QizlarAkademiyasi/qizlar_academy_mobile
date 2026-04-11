import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/constants/app_margin.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_banners_carousel.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_category_item.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_guest_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_stats_section.dart';

mixin HomeScreenMixin<T extends StatefulWidget> on State<T> {
  void _pushSignInDeferred(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      context.push(Routes.signIn);
    });
  }

  Widget buildHeader(BuildContext context, {String userGreetingName = ''}) {
    final isAnonymous = getIt<AuthSessionCubit>().state.isAnonymous;
    final l10n = context.l10n;
    final title = isAnonymous ? l10n.homeWelcomeGuestTitle : _registeredHeaderTitle(context, userGreetingName);
    final subtitle = isAnonymous ? l10n.homeWelcomeGuestSubtitle : l10n.homeWelcomeBack;

    return HomeHeaderComponent(title: title, subtitle: subtitle, onNotificationTap: () => onNotificationTap(context));
  }

  String _registeredHeaderTitle(BuildContext context, String userGreetingName) {
    final trimmed = userGreetingName.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return context.l10n.homeRegisteredUserFallback;
  }

  Widget buildStoryBoard(BuildContext context, List<StoryModel> stories) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.appColors.background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: AppGap.gapSm),
              itemCount: stories.length,
              itemBuilder: (context, index) => StoryBoardItem(story: stories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsSection(BuildContext context, HomeStatsModel stats, {bool isLoading = false, VoidCallback? onCoinsAndGradeTap, VoidCallback? onRatingTap, VoidCallback? onLastLessonTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [HomeStatsSection(stats: stats, isLoading: isLoading, onCoinsAndGradeTap: onCoinsAndGradeTap, onRatingTap: onRatingTap, onLastLessonTap: onLastLessonTap)],
    );
  }

  Widget buildGuestCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [HomeGuestCard(onPressed: () => _pushSignInDeferred(context))],
    );
  }

  /// Kurs kartasiga bosilganda detallar sahifasiga o‘tkazadi.
  Future<void> openCourseDetails(BuildContext context, String courseId) async {
    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'home_course_$courseId', title: context.l10n.homeGuestCoursesGate);
    if (!canOpen) return;
    if (!context.mounted) return;
    context.push(Routes.courseDetails(courseId));
  }

  Future<void> onNotificationTap(BuildContext context) async {
    if (getIt<AuthSessionCubit>().state.isAnonymous) {
      _pushSignInDeferred(context);
      return;
    }
    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'home_notification_bell', title: context.l10n.homeGuestNotificationsGate);
    if (!canOpen) return;
    if (!context.mounted) return;
    context.push(Routes.notification);
  }

  Widget buildCoursesSection(BuildContext context, List<CourseModel> courses, {bool isLoading = false}) {
    return Padding(
      padding: AppMargin.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.homePopularCourses, style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
          const SizedBox(height: AppGap.gapSm),
          ...courses.map((course) => HomeCourseCard(course: course, isLoading: isLoading, onTap: () => openCourseDetails(context, course.id))),
        ],
      ),
    );
  }

  Widget buildBannersSection(BuildContext context, List<BannerModel> banners, {bool isLoading = false}) {
    return HomeBannersCarousel(banners: banners, isLoading: isLoading);
  }
}
