import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
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
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_banners_carousel.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_category_item.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_guest_card.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_stats_section.dart';

mixin HomeScreenMixin<T extends StatefulWidget> on State<T> {
  Widget buildHeader(BuildContext context, String userName) {
    return HomeHeaderComponent(
      userName: userName,
      onNotificationTap: () => onNotificationTap(context),
    );
  }

  String resolveUserName() {
    return getIt<AuthSessionCubit>().state.isAnonymous
        ? 'Mehmon foydalanuvchi'
        : 'Ro‘yxatdan o‘tgan foydalanuvchi';
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
              itemBuilder: (context, index) =>
                  StoryBoardItem(story: stories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsSection(
    BuildContext context,
    HomeStatsModel stats, {
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [HomeStatsSection(stats: stats, isLoading: isLoading)],
    );
  }

  Widget buildGuestCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeGuestCard(onPressed: () => context.push(Routes.signIn)),
      ],
    );
  }

  /// Kurs kartasiga bosilganda detallar sahifasiga o‘tkazadi.
  Future<void> openCourseDetails(BuildContext context, String courseId) async {
    final canOpen = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'home_course_$courseId',
      title: 'Kurslarni to‘liq ko‘rish uchun ro‘yxatdan o‘ting',
    );
    if (!canOpen) return;
    if (!context.mounted) return;
    context.push(Routes.courseDetails(courseId));
  }

  Future<void> onNotificationTap(BuildContext context) async {
    final canOpen = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'home_notification_bell',
      title: 'Bildirishnomalar uchun ro‘yxatdan o‘ting',
    );
    if (!canOpen) return;
    if (!context.mounted) return;
    context.push(Routes.notification);
  }

  Widget buildCoursesSection(
    BuildContext context,
    List<CourseModel> courses, {
    bool isLoading = false,
  }) {
    return Padding(
      padding: AppMargin.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mashhur kurslar',
            style: context.textTheme.heading6.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: AppGap.gapSm),
          ...courses.map(
            (course) => HomeCourseCard(
              course: course,
              isLoading: isLoading,
              onTap: () => openCourseDetails(context, course.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBannersSection(
    BuildContext context,
    List<BannerModel> banners, {
    bool isLoading = false,
  }) {
    return HomeBannersCarousel(banners: banners, isLoading: isLoading);
  }

  void homeBlocListener(BuildContext context, HomeState state) {
    if (state.status == HomeStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message ?? 'Xatolik yuz berdi'),
          backgroundColor: AppColors.redAction,
        ),
      );
    }
  }
}
