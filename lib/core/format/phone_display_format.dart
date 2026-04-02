/// +998 dan keyingi 9 ta raqam (faqat raqamlar).
String extractUzbekNationalDigits(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('998') && digits.length >= 12) {
    return digits.substring(3, 12);
  }
  if (digits.length >= 9) {
    return digits.substring(digits.length - 9);
  }
  return digits;
}

/// Milliy 9 raqamni ko‘rinish uchun bo‘shliqlar bilan (masalan `99 123 45 67`).
String formatUzbekNationalDigitsForDisplay(String nineDigits) {
  final d = nineDigits.replaceAll(RegExp(r'[^0-9]'), '');
  if (d.isEmpty) return '';
  final buf = StringBuffer();
  for (var i = 0; i < d.length && i < 9; i++) {
    if (i == 2 || i == 5 || i == 7) buf.write(' ');
    buf.write(d[i]);
  }
  return buf.toString();
}

/// Telefon qatorini UI uchun qisqacha formatlaydi (masalan +998 90 123-45-67).
String formatPhoneForDisplay(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length < 12) return trimmed;
  final code = digits.substring(0, 3);
  final first = digits.substring(3, 5);
  final second = digits.substring(5, 8);
  final third = digits.substring(8, 10);
  final fourth = digits.substring(10, 12);
  return '+$code $first $second-$third-$fourth';
}

/// Profil sarlavhasidagi ikkinchi qator matni: `Telefon: +998 …` yoki bo‘sh bo‘lsa `Telefon: —`.
String profilePhoneSubtitleLine(String phoneNumber) {
  final trimmed = phoneNumber.trim();
  if (trimmed.isEmpty) return 'Telefon: —';
  final formatted = formatPhoneForDisplay(trimmed);
  final line = formatted.isNotEmpty ? formatted : trimmed;
  return line;
}
