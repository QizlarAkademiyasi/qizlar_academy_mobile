import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class ReferralLeaderboardUserModel extends Equatable {
  const ReferralLeaderboardUserModel({
    required this.rank,
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.referralCode,
    required this.certificatesEarned,
    required this.badge,
    required this.isCurrentUser,
    this.photoUrl,
  });

  final int rank;
  final String userId;
  final String firstname;
  final String lastname;
  final String referralCode;
  final int certificatesEarned;
  final int badge;
  final bool isCurrentUser;
  final String? photoUrl;

  String get fullName {
    final first = firstname.trim();
    final last = lastname.trim();
    if (first.isEmpty && last.isEmpty) return 'Foydalanuvchi';
    if (first.isEmpty) return last;
    if (last.isEmpty) return first;
    return '$first $last';
  }

  String get shortName {
    final first = firstname.trim();
    if (first.isNotEmpty) return first;
    return fullName.split(' ').first;
  }

  String get initials {
    final first = firstname.trim();
    final last = lastname.trim();
    if (first.isEmpty && last.isEmpty) return 'F';
    final firstLetter = first.isNotEmpty ? first.characters.first : '';
    final secondLetter = last.isNotEmpty ? last.characters.first : '';
    return '$firstLetter$secondLetter'.toUpperCase();
  }

  @override
  List<Object?> get props => [
    rank,
    userId,
    firstname,
    lastname,
    referralCode,
    certificatesEarned,
    badge,
    isCurrentUser,
    photoUrl,
  ];
}
