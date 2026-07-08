import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class PortfolioAuthorModel extends Equatable {
  const PortfolioAuthorModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photoUrl,
  });

  final String id;
  final String firstname;
  final String lastname;
  final String photoUrl;

  String get fullName => '$firstname $lastname'.trim();

  @override
  List<Object?> get props => [id, firstname, lastname, photoUrl];
}
