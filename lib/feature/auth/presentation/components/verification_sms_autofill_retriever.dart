import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Android’da [Pinput] SMS autofill uchun [sms_autofill] orqali [SmsRetriever].
final class VerificationSmsAutofillRetriever implements SmsRetriever {
  VerificationSmsAutofillRetriever({this.codeLength = 6});

  final int codeLength;
  final SmsAutoFill _sms = SmsAutoFill();

  @override
  bool get listenForMultipleSms => false;

  @override
  Future<void> dispose() => _sms.unregisterListener();

  @override
  Future<String?> getSmsCode() async {
    final pattern = '\\d{$codeLength,$codeLength}';
    try {
      await _sms.listenForCode(smsCodeRegexPattern: pattern);
      return await _sms.code.firstWhere((c) => c.length == codeLength).timeout(
            const Duration(minutes: 3),
          );
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    } finally {
      await _sms.unregisterListener();
    }
  }
}
