abstract interface class ReferralRepository {
  String? readPendingCode();
  Future<void> savePendingCode(String code);
  Future<void> clearPendingCode();
  Future<void> useReferralCode({required String code});
}
