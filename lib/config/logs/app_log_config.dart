/// Barcha [AppLogger] chiqishlarining yagona kaliti.
///
/// [EnvConfig.initialize] chaqirilganda avtomatik yangilanadi: **dev** → `true`, **prod** → `false`.
/// Vaqtincha yoki mahalliy sinov uchun [loggingEnabled] ni qo‘lda ham o‘zgartirish mumkin.
abstract final class AppLogConfig {
  AppLogConfig._();

  static bool loggingEnabled = true;
}
