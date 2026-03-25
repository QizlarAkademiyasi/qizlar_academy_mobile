import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor(this._dio, this._authSessionCubit);

  static const String _retryKey = 'hasRetriedWithRefresh';

  final Dio _dio;
  final AuthSessionCubit _authSessionCubit;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) {
      handler.next(err);
      return;
    }

    final requestOptions = err.requestOptions;
    final bool isRefreshCall = requestOptions.path == Apis.authRefresh;
    final bool skipRefresh = requestOptions.extra[skipAuthRefresh] == true;
    final bool hasRetried = requestOptions.extra[_retryKey] == true;

    if (isRefreshCall || skipRefresh || hasRetried) {
      handler.next(err);
      return;
    }

    final refreshedToken = await _authSessionCubit.refreshAccessToken();
    if ((refreshedToken ?? '').isEmpty) {
      handler.next(err);
      return;
    }

    requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
    requestOptions.extra[_retryKey] = true;

    try {
      final response = await _dio.fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

const String skipAuthRefresh = 'skipAuthRefresh';
