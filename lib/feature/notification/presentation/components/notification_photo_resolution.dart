import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

({String url, Map<String, String>? headers}) notificationPhotoRequest(
  String? raw,
) {
  final trimmed = raw?.trim() ?? '';
  if (trimmed.isEmpty) {
    return (url: '', headers: null);
  }
  final token = getIt<AuthSessionCubit>().state.accessToken;
  final headers = (token != null && token.isNotEmpty)
      ? {'Authorization': 'Bearer $token'}
      : null;
  return (url: Apis.resolveUrl(trimmed), headers: headers);
}
