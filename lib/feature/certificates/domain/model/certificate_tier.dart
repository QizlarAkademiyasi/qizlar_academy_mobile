/// Sertifikat darajasi — API `type` qatori bilan moslashtiriladi.
enum CertificateTier { gold, silver, bronze }

CertificateTier certificateTierFromApiType(String raw) {
  final t = raw.trim().toLowerCase();
  if (t.contains('gold') || t.contains('oltin') || t.contains('золот')) {
    return CertificateTier.gold;
  }
  if (t.contains('silver') || t.contains('kumush') || t.contains('серебр')) {
    return CertificateTier.silver;
  }
  if (t.contains('bronze') || t.contains('bronza') || t.contains('бронз')) {
    return CertificateTier.bronze;
  }
  return CertificateTier.silver;
}
