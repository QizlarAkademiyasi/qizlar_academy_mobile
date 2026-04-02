import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';

/// Too many OTP SMS requests (429) on [AnonymousApis.authOtpPhoneNumber].
bool isAuthOtpPhoneThrottledResponse(DioException error) {
  if (error.response?.statusCode != 429) return false;
  return error.requestOptions.path == AnonymousApis.authOtpPhoneNumber;
}

/// OTP telefon so'rovida backend ruxsat etilgan operator prefikslariga mos kelmasa 400 qaytaradi.
bool isAuthOtpPhoneOperatorRestrictedResponse(DioException error) {
  if (error.response?.statusCode != 400) return false;
  final data = error.response?.data;
  if (data is! Map) return false;
  final raw = data['message'];
  final parts = <String>[];
  if (raw is String) {
    parts.add(raw);
  } else if (raw is List) {
    for (final item in raw) {
      parts.add(item.toString());
    }
  }
  for (final text in parts) {
    final lower = text.toLowerCase();
    if (lower.contains('phone') &&
        lower.contains('must match') &&
        lower.contains('998') &&
        lower.contains('regular expression')) {
      return true;
    }
  }
  return false;
}
