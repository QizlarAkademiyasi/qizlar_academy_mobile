import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/home_screen_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with HomeScreenMixin<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: homeBlocListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: switch (state.status) {
              HomeStatus.initial || HomeStatus.loading => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              HomeStatus.failure => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.circleX, color: AppColors.redAction, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      state.message ?? 'Xatolik yuz berdi',
                      style: context.textTheme.bodyLargeRegular.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              HomeStatus.success => _buildContent(context, state),
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: buildHeader(context, 'Aziza')),
        SliverToBoxAdapter(child: const SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: buildCategoriesRow(context, state.categories),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: buildStatsSection(context, state.homeStats!),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: buildTeachersRow(context, state.teachers),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: buildCoursesSection(context, state.courses),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 24)),
      ],
    );
  }
}
