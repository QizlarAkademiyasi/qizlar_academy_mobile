import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreCategoryModel extends Equatable {
  const StoreCategoryModel({required this.id, required this.name, this.productCount = 0});

  final String id;
  final String name;
  final int productCount;

  @override
  List<Object?> get props => [id, name, productCount];
}
