import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/bloc/portfolio_create_bloc.dart';

mixin PortfolioCreateScreenMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController captionController;

  @override
  void initState() {
    super.initState();
    captionController = TextEditingController();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  void portfolioCreateBlocListener(
    BuildContext context,
    PortfolioCreateState state,
  ) {
    if (state.status == PortfolioCreateStatus.success) {
      AppToast.success(context, message: 'Portfolio joylandi');
      context.pop(true);
      return;
    }
    if (state.status == PortfolioCreateStatus.failure &&
        state.message != null) {
      AppToast.error(context, message: state.message!);
    }
  }

  void onCloseTap(BuildContext context) {
    Gaimon.light();
    context.pop(false);
  }

  void onCaptionChanged(BuildContext context, String value) {
    context.read<PortfolioCreateBloc>().add(
      PortfolioCreateCaptionChanged(value),
    );
  }

  Future<void> onAddImageTap(BuildContext context) async {
    Gaimon.light();
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(
      imageQuality: 86,
      maxWidth: 2048,
    );
    if (!context.mounted || picked.isEmpty) return;
    for (final file in picked) {
      context.read<PortfolioCreateBloc>().add(
        PortfolioCreateMediaAdded(
          localFilePath: file.path,
          type: PortfolioMediaType.image,
        ),
      );
    }
  }

  void onRemoveMedia(BuildContext context, int index) {
    context.read<PortfolioCreateBloc>().add(PortfolioCreateMediaRemoved(index));
  }

  void onSubmit(BuildContext context) {
    Gaimon.light();
    context.read<PortfolioCreateBloc>().add(const PortfolioCreateSubmitted());
  }
}
