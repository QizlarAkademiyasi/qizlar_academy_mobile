import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class ReferralCodeModel extends Equatable {
  const ReferralCodeModel({
    required this.referralCode,
    required this.referralLink,
  });

  final String referralCode;
  final String referralLink;

  @override
  List<Object?> get props => [referralCode, referralLink];
}
