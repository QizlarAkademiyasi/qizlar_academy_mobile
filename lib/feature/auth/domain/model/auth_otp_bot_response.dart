import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Telegram bot OTP so'rovi javobi: [keyHash] tasdiqlash / signin uchun; [link] botga o'tish.
class AuthOtpBotResponse extends Equatable {
  const AuthOtpBotResponse({required this.keyHash, required this.link});

  final String keyHash;
  final String link;

  @override
  List<Object?> get props => [keyHash, link];
}
