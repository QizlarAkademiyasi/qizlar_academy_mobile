import 'package:qizlar_academy_mobile/feature/privacy_policy/data/datasource/privacy_policy_asset_datasource.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/domain/repository/privacy_policy_repository.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl({PrivacyPolicyAssetDatasource? assetDatasource})
      : _asset = assetDatasource ?? const PrivacyPolicyAssetDatasource();

  final PrivacyPolicyAssetDatasource _asset;

  @override
  Future<String> loadMarkdown() => _asset.loadMarkdown();
}
