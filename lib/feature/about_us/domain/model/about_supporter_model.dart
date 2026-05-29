import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Qo'llab-quvvatlovchi — matnlar l10n, rasm URL manbada.
class AboutSupporterModel extends Equatable {
  const AboutSupporterModel({required this.id, required this.imageUrl});

  /// L10n kalitlari bilan bog'lash uchun barqaror id (masalan: sadulla).
  final String id;
  final String imageUrl;

  @override
  List<Object?> get props => [id, imageUrl];
}
