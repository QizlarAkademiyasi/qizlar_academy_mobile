enum StorageKey {
  /// So‘nggi muvaffaqiyatli Remote Config dan olingan API domeni (tarmoq yo‘qida qayta ishlatiladi).
  remoteConfigLastResolvedDomain,

  accessToken,
  refreshToken,
  userType,
  tokenType,
  language,
  fcmToken,
  pinCodeExist,
  theme,

  userDashboard,
  userMe,
  userId,

  authKey,
  authKeyInfo,

  partIds,
  videoProgress,

  /// Deep link orqali kelgan, hali API ga yuborilmagan referral kodi.
  pendingReferralCode,

  /// Prefetch qilingan kun uchun streak JSON (`daily_streak_daily_fetch_service`).
  dailyStreakSnapshotV1,

  /// Shu kalend kunida kunlik tanga sheet ochilgan — takroriy auto-sheet yo‘q.
  dailyCoinSheetEngagedDayV1,
}
