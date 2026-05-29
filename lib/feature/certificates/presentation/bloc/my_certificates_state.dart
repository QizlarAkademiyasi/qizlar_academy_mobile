part of 'my_certificates_bloc.dart';

enum MyCertificatesStatus { initial, loading, success, failure }

class MyCertificatesState extends Equatable {
  const MyCertificatesState({this.status = MyCertificatesStatus.initial, this.items = const []});

  final MyCertificatesStatus status;
  final List<CertificateItemModel> items;

  @override
  List<Object?> get props => [status, items];
}
