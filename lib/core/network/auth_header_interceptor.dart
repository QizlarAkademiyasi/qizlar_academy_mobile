import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

class AuthHeaderInterceptor extends Interceptor {
  AuthHeaderInterceptor(this._authSessionCubit);

  final AuthSessionCubit _authSessionCubit;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = _authSessionCubit.state.accessToken;
    if ((accessToken ?? '').isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }
}
