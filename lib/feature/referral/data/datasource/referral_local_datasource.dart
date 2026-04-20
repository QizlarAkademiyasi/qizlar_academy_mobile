import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';

abstract interface class ReferralLocalDatasource {
  String? readPendingCode();
  Future<void> savePendingCode(String code);
  Future<void> clearPendingCode();
}

class ReferralLocalDatasourceImpl implements ReferralLocalDatasource {
  const ReferralLocalDatasourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static String get _key => StorageKey.pendingReferralCode.name;

  @override
  String? readPendingCode() {
    final value = _prefs.getString(_key);
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  @override
  Future<void> savePendingCode(String code) async {
    await _prefs.setString(_key, code.trim());
  }

  @override
  Future<void> clearPendingCode() async {
    await _prefs.remove(_key);
  }
}
