import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';

/// Wrong or expired OTP: 401 on [AnonymousApis.authSignIn].
bool isAuthSignInOtpRejectedResponse(DioException error) {
  if (error.response?.statusCode != 401) return false;
  return error.requestOptions.path == AnonymousApis.authSignIn;
}
