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
}