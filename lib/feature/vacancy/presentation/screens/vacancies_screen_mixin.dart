import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/components/my_courses_top_bar.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_item_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/bloc/vacancy_bloc.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/components/vacancy_card.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';

mixin VacanciesScreenMixin<T extends StatefulWidget> on State<T> {
  void vacancyBlocListener(BuildContext context, VacancyState state) {
    if (!state.loadMoreFailed) return;
    AppToast.error(context, message: context.l10n.vacanciesLoadMoreError);
    context.read<VacancyBloc>().add(const VacancyLoadMoreFailureConsumed());
  }

  void onVacanciesBackTap(BuildContext context) {
    Gaimon.light();
    context.pop();
  }

  void onVacancyScrollNearEnd(BuildContext context) {
    context.read<VacancyBloc>().add(const VacancyLoadMoreRequested());
  }

  void retryVacanciesFirstPage(BuildContext context) {
    context.read<VacancyBloc>().add(const VacancyRetryRequested());
  }

  void onVacancyDetailTap(BuildContext context, VacancyItemModel item) {
    Gaimon.light();
    context.push(Routes.vacancyDetailPath(item.id));
  }

  Widget buildVacanciesTopBar(BuildContext context) {
    return MyCoursesTopBar(title: context.l10n.vacanciesTitle, onBackTap: () => onVacanciesBackTap(context));
  }

  Widget buildVacancyListItem(BuildContext context, {required VacancyState state, required int index}) {
    final item = state.items[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: VacancyCard(item: item, onDetailTap: () => onVacancyDetailTap(context, item)),
    );
  }
}
