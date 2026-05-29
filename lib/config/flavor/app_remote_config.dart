import 'dart:async';
import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/remote_config_feature_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/remote_config_force_update_keys.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

final class AppRemoteConfig {
  final String domain;

  /// Remote Config `google_sign_in` — `true` bo‘lsa Google Sign-In UI yoqilgan.
  final bool googleSignInEnabled;

  AppRemoteConfig._(this.domain, this.googleSignInEnabled);

  static AppRemoteConfig? _instance;

  static AppRemoteConfig get instance {
    assert(
      _instance != null,
      'AppRemoteConfig.initialize() chaqirilmagan. '
      'setupLocator() ichida chaqirilganini tekshiring.',
    );
    return _instance!;
  }

  /// Remote Config: qisqaroq tarmoq timeout, xatolikda [activate], domen bo‘yicha disk keshi.
  static Future<void> initialize(SharedPreferences prefs) async {
    final totalSw = Stopwatch()..start();
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 12),
        minimumFetchInterval: EnvConfig.instance.isDev ? Duration.zero : const Duration(hours: 1),
      ),
    );

    final cachedDomain = prefs.getString(StorageKey.remoteConfigLastResolvedDomain.name)?.trim() ?? '';
    final defaults = <String, Object>{
      RemoteConfigForceUpdateKeys.applicationStoreLink: 'https://onelink.to/4h9hr9',
      RemoteConfigForceUpdateKeys.currentAppVersion: '1.7.0',
      RemoteConfigForceUpdateKeys.minimumSupportedAppVersion: '1.7.0',
      RemoteConfigFeatureKeys.googleSignIn: false,
      AppFlavors.prod.remoteConfigKey: EnvConfig.instance.isDev ? '' : cachedDomain,
      AppFlavors.dev.remoteConfigKey: EnvConfig.instance.isDev ? cachedDomain : '',
    };
    await remoteConfig.setDefaults(defaults);

    final fetchSw = Stopwatch()..start();
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e, st) {
      AppLogger.w(
        'Remote Config fetchAndActivate failed; trying activate()',
        error: e,
        stackTrace: st,
      );
      try {
        await remoteConfig.activate();
      } catch (e2, st2) {
        AppLogger.w('Remote Config activate failed', error: e2, stackTrace: st2);
      }
    }
    final fetchMs = fetchSw.elapsedMilliseconds;

    final baseUrlRaw = remoteConfig.getString(AppFlavors.prod.remoteConfigKey);
    final devUrlRaw = remoteConfig.getString(AppFlavors.dev.remoteConfigKey);

    final baseDomain = _extractDomain(baseUrlRaw);
    final devDomain = _extractDomain(devUrlRaw);
    final rcResolved = EnvConfig.instance.isDev ? devDomain : baseDomain;
    var resolvedDomain = rcResolved;
    if (resolvedDomain.isEmpty) {
      resolvedDomain = cachedDomain;
    }
    final usedCachedDomainFallback = resolvedDomain.isNotEmpty && rcResolved.isEmpty && cachedDomain.isNotEmpty;

    final googleSignInEnabled = remoteConfig.getBool(RemoteConfigFeatureKeys.googleSignIn);

    _instance = AppRemoteConfig._(resolvedDomain, googleSignInEnabled);
    if (resolvedDomain.isNotEmpty) {
      await prefs.setString(StorageKey.remoteConfigLastResolvedDomain.name, resolvedDomain);
    }

    final forceUpdateStoreLink = remoteConfig.getString(RemoteConfigForceUpdateKeys.applicationStoreLink).trim();
    final forceUpdateCurrent = remoteConfig.getString(RemoteConfigForceUpdateKeys.currentAppVersion).trim();
    final forceUpdateMinimum = remoteConfig.getString(RemoteConfigForceUpdateKeys.minimumSupportedAppVersion).trim();

    AppLogger.i(<String, dynamic>{
      'remoteConfig': 'domain + force_update (startup)',
      'flavor': EnvConfig.instance.flavor.name,
      'fetchAndActivate_ms': fetchMs,
      'initialize_total_ms': totalSw.elapsedMilliseconds,
      'baseDomain': baseDomain,
      'devDomain': devDomain,
      'resolvedDomain': resolvedDomain,
      'usedCachedDomainFallback': usedCachedDomainFallback,
      RemoteConfigForceUpdateKeys.applicationStoreLink: forceUpdateStoreLink,
      RemoteConfigForceUpdateKeys.currentAppVersion: forceUpdateCurrent,
      RemoteConfigForceUpdateKeys.minimumSupportedAppVersion: forceUpdateMinimum,
      RemoteConfigFeatureKeys.googleSignIn: googleSignInEnabled,
    });

    unawaited(_refreshRemoteConfigInBackground(remoteConfig, prefs));
  }

  /// Keyingi ochilishda yangi qiymat olish uchun; birinchi freymni bloklamaydi.
  static Future<void> _refreshRemoteConfigInBackground(
    FirebaseRemoteConfig remoteConfig,
    SharedPreferences prefs,
  ) async {
    try {
      final ok = await remoteConfig.fetchAndActivate();
      AppLogger.i(<String, dynamic>{
        'remoteConfig': 'background_fetchAndActivate',
        'activated_new_values': ok,
      });
      final baseUrlRaw = remoteConfig.getString(AppFlavors.prod.remoteConfigKey);
      final devUrlRaw = remoteConfig.getString(AppFlavors.dev.remoteConfigKey);
      final baseDomain = _extractDomain(baseUrlRaw);
      final devDomain = _extractDomain(devUrlRaw);
      final resolved = EnvConfig.instance.isDev ? devDomain : baseDomain;
      if (resolved.isNotEmpty) {
        await prefs.setString(StorageKey.remoteConfigLastResolvedDomain.name, resolved);
      }
    } catch (e, st) {
      AppLogger.w('Remote Config background fetch failed', error: e, stackTrace: st);
    }
  }

  static String _extractDomain(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return '';

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final normalized = value.replaceAll("'", '"');
    try {
      final decoded = jsonDecode(normalized);
      if (decoded is Map<String, dynamic>) {
        return (decoded['domain'] ?? '').toString().trim();
      }
      if (decoded is Map) {
        return (decoded['domain'] ?? '').toString().trim();
      }
    } catch (_) {
      // Remote Config qiymati JSON bo'lmasa, quyida regex bilan tekshiriladi.
    }

    final match = RegExp(r'https?:\/\/[A-Za-z0-9\.\-:_~\/\?#\[\]@!\$&\(\)\*\+,;=%]+').firstMatch(value);
    return match?.group(0)?.trim() ?? '';
  }
}
