import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class ProfileLanguageOptionModel extends Equatable {
  const ProfileLanguageOptionModel({
    required this.code,
    required this.title,
    required this.flagEmoji,
  });

  final String code;
  final String title;
  final String flagEmoji;

  @override
  List<Object?> get props => [code, title, flagEmoji];
}
