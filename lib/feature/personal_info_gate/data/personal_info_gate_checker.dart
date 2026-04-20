import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

/// Kurs detali va lesson tugaganda shaxsiy ma'lumotlar to'liq to'ldirilganligini tekshiradi.
///
/// Bosqichlar:
/// - 0: Manzil (region, district, neighborhood)
/// - 1: Tug'ilgan sana (birthday)
/// - 2: Ta'lim turi (education type)
///
/// Har bir bosqich alohida PATCH qilinadi va SharedPreferences'da keshlanadi.
class PersonalInfoGateChecker {
  PersonalInfoGateChecker(this._dio, this._prefs);

  final Dio _dio;
  final SharedPreferences _prefs;

  static const _prefKeyAll = 'personal_info_gate_completed';
  static const _prefKeyStep0 = 'personal_info_gate_step_0';
  static const _prefKeyStep1 = 'personal_info_gate_step_1';
  static const _prefKeyStep2 = 'personal_info_gate_step_2';

  /// Barcha bosqichlar muvaffaqiyatli o'tilganmi?
  bool get isCompleted => _prefs.getBool(_prefKeyAll) ?? false;

  /// Belgilangan bosqich keshda bajarilganmi?
  bool isStepCompleted(int step) {
    switch (step) {
      case 0:
        return _prefs.getBool(_prefKeyStep0) ?? false;
      case 1:
        return _prefs.getBool(_prefKeyStep1) ?? false;
      case 2:
        return _prefs.getBool(_prefKeyStep2) ?? false;
      default:
        return false;
    }
  }

  /// Bosqich muvaffaqiyatli PATCH qilinganidan keyin keshga yozish.
  Future<void> markStepCompleted(int step) async {
    switch (step) {
      case 0:
        await _prefs.setBool(_prefKeyStep0, true);
      case 1:
        await _prefs.setBool(_prefKeyStep1, true);
      case 2:
        await _prefs.setBool(_prefKeyStep2, true);
    }
    if (isStepCompleted(0) && isStepCompleted(1) && isStepCompleted(2)) {
      await _prefs.setBool(_prefKeyAll, true);
    }
  }

  /// Cache'ni tozalash (masalan, logout'da).
  Future<void> reset() async {
    await _prefs.remove(_prefKeyAll);
    await _prefs.remove(_prefKeyStep0);
    await _prefs.remove(_prefKeyStep1);
    await _prefs.remove(_prefKeyStep2);
  }

  /// Backend'dan user ma'lumotlarini tekshiradi va keyingi to'ldirilmagan
  /// bosqich raqamini qaytaradi. Hammasi to'liq bo'lsa `null`.
  Future<int?> nextPendingStep() async {
    if (isCompleted) return null;
    try {
      final response = await _dio.get<dynamic>('/api/v1/user/me');
      final envelope = response.data;
      if (envelope is! Map<String, dynamic>) return _firstMissingFromCache();
      final data = envelope['data'];
      if (data is! Map<String, dynamic>) return _firstMissingFromCache();

      final address = data['address'];
      final education = data['education'] ?? data['educaton'];
      final hasAddress = _hasAddress(address);
      final hasBirthday = _hasBirthday(data);
      final hasEduType = _hasEducationType(education);

      // Keshni API natijasiga sinxronlashtirish
      if (hasAddress && !isStepCompleted(0)) await markStepCompleted(0);
      if (hasBirthday && !isStepCompleted(1)) await markStepCompleted(1);
      if (hasEduType && !isStepCompleted(2)) await markStepCompleted(2);

      if (!hasAddress) return 0;
      if (!hasBirthday) return 1;
      if (!hasEduType) return 2;

      // Hammasi to'liq
      await _prefs.setBool(_prefKeyAll, true);
      return null;
    } catch (e, st) {
      AppLogger.w('PersonalInfoGateChecker: tekshirishda xato', error: e, stackTrace: st);
      return null;
    }
  }

  /// Eski API bilan moslik uchun.
  Future<bool> needsPersonalInfo() async {
    final step = await nextPendingStep();
    return step != null;
  }

  /// Barcha bosqichlar to'liq deb belgilash.
  Future<void> markCompleted() => _prefs.setBool(_prefKeyAll, true);

  int? _firstMissingFromCache() {
    if (!isStepCompleted(0)) return 0;
    if (!isStepCompleted(1)) return 1;
    if (!isStepCompleted(2)) return 2;
    return null;
  }

  bool _hasAddress(dynamic address) {
    if (address is! Map<String, dynamic>) return false;
    final region = (address['region'] ?? '').toString().trim();
    final district = (address['district'] ?? '').toString().trim();
    final neighborhood = (address['neighborhood'] ?? '').toString().trim();
    return region.isNotEmpty && district.isNotEmpty && neighborhood.isNotEmpty;
  }

  bool _hasBirthday(Map<String, dynamic> data) {
    return (data['birthday'] ?? '').toString().trim().isNotEmpty;
  }

  bool _hasEducationType(dynamic education) {
    if (education is! Map<String, dynamic>) return false;
    return (education['type'] ?? '').toString().trim().isNotEmpty;
  }
}
