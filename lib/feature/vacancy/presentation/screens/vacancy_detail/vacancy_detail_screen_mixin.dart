import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/bloc/vacancy_detail_bloc.dart';

mixin VacancyDetailScreenMixin<T extends StatefulWidget> on State<T> {
  void vacancyDetailBlocListener(BuildContext context, VacancyDetailState state) {
    if (state.status != VacancyDetailStatus.failure || state.message == null) return;
    AppToast.error(context, message: context.l10n.vacancyDetailLoadError);
  }

  void onVacancyDetailBackTap(BuildContext context) {
    Gaimon.light();
    context.pop();
  }

  void onVacancyDetailApplyTap(BuildContext context) {
    Gaimon.light();
    AppToast.info(context, message: context.l10n.vacancyApplyPlaceholder);
  }
}
