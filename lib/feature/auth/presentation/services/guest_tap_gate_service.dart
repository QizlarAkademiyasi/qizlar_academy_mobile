import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/auth_required_bottom_sheet.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

class GuestTapGateService {
  final Set<String> _shownKeys = <String>{};

  bool get _isAnonymous => getIt<AuthSessionCubit>().state.isAnonymous;

  Future<bool> allowAction(
    BuildContext context, {
    required String key,
    String? title,
    String? description,
  }) async {
    if (!_isAnonymous) return true;
    if (_shownKeys.contains(key)) return true;

    _shownKeys.add(key);
    await showAuthRequiredBottomSheet(
      context,
      title: title,
      description: description,
    );
    return false;
  }

  void reset() => _shownKeys.clear();
}
