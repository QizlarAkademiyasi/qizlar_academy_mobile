import 'dart:math' as math;

/// O‘rnatilgan ilova versiyasini `pubspec` / PackageInfo formatidan normalize qiladi.
String normalizeSemanticVersionString(String raw) {
  var v = raw.trim();
  if (v.isEmpty) return v;
  final plus = v.indexOf('+');
  if (plus != -1) {
    v = v.substring(0, plus);
  }
  final prerelease = v.indexOf('-');
  if (prerelease != -1) {
    v = v.substring(0, prerelease);
  }
  return v.trim();
}

/// Semver bo‘yicha solishtirish: `a < b` → manfiy, teng → 0, `a > b` → musbat.
int compareSemanticVersions(String a, String b) {
  final pa = _parseParts(normalizeSemanticVersionString(a));
  final pb = _parseParts(normalizeSemanticVersionString(b));
  final len = math.max(pa.length, pb.length);
  for (var i = 0; i < len; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    final c = x.compareTo(y);
    if (c != 0) return c;
  }
  return 0;
}

List<int> _parseParts(String v) {
  if (v.isEmpty) return const <int>[0];
  return v
      .split('.')
      .map((s) => int.tryParse(s.trim()) ?? 0)
      .toList(growable: false);
}
