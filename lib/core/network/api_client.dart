import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/network/app_network_logger_interceptor.dart';
import 'package:qizlar_academy_mobile/core/network/auth_header_interceptor.dart';
import 'package:qizlar_academy_mobile/core/network/insecure_ssl_override.dart';
import 'package:qizlar_academy_mobile/core/network/token_refresh_interceptor.dart';
import 'package:qizlar_academy_mobile/core/watchdog/watchdog_integrations.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

class ApiClientFactory {
  const ApiClientFactory._();

  static Dio create(AuthSessionCubit authSessionCubit) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Apis.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    applyInsecureSslOverride(dio);

    dio.interceptors.addAll([
      AppNetworkLoggerInterceptor(),
      AuthHeaderInterceptor(authSessionCubit),
      TokenRefreshInterceptor(dio, authSessionCubit),
    ]);
    // Last, so the captured request carries the final auth headers.
    attachWatchdogToDio(dio);
    return dio;
  }
}
