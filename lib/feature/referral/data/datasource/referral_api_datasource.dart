import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';

abstract interface class ReferralRemoteDatasource {
  Future<void> useReferralCode({required String code});
}

class ReferralApiDatasource implements ReferralRemoteDatasource {
  const ReferralApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<void> useReferralCode({required String code}) async {
    await _dio.post<dynamic>(
      UserApis.referralUse,
      data: <String, dynamic>{'code': code},
    );
  }
}
