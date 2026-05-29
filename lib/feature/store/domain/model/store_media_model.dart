import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreMediaModel extends Equatable {
  const StoreMediaModel({required this.id, required this.url});

  final String id;
  final String url;

  @override
  List<Object?> get props => [id, url];
}
