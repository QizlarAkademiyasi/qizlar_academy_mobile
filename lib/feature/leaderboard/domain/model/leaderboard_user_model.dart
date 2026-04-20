import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class LeaderboardUserModel extends Equatable {
  const LeaderboardUserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photoUrl,
    required this.rank,
    required this.coins,
    required this.rating,
    required this.isCurrentUser,
  });

  final String id;
  final String firstname;
  final String lastname;
  final String photoUrl;
  final int rank;
  final int coins;
  final double rating;
  final bool isCurrentUser;

  String get fullName {
    final first = firstname.trim();
    final last = lastname.trim();
    if (first.isEmpty && last.isEmpty) return 'Foydalanuvchi';
    if (last.isEmpty) return first;
    if (first.isEmpty) return last;
    return '$first $last';
  }

  String get avatarUrl => photoUrl;

  @override
  List<Object?> get props => [id, firstname, lastname, photoUrl, rank, coins, rating, isCurrentUser];
}
