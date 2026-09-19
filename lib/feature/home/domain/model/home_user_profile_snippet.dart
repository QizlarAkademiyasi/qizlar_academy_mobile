import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Home salom qatori uchun `/me` dan olingan qisqa profil.
class HomeUserProfileSnippet extends Equatable {
  const HomeUserProfileSnippet({
    this.greetingName = '',
    this.badgeId = 0,
  });

  final String greetingName;
  final int badgeId;

  static const empty = HomeUserProfileSnippet();

  @override
  List<Object?> get props => [greetingName, badgeId];
}
