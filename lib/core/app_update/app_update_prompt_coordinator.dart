import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/remote_config_force_update_keys.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/core/app_update/app_update_prompt_scope.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_update_available_dialog.dart';
import 'package:qizlar_academy_mobile/core/version/semantic_version_compare.dart';

/// Remote Config dagi [CURRENT_APP_VERSION] dan past bo‘lsa — ixtiyoriy yangilash dialogi;
/// [MINIMUM_SUPPORTED_APP_VERSION] dan past bo‘lsa — majburiy (faqat “Yangilash”).
final class AppUpdatePromptCoordinator {
  AppUpdatePromptCoordinator._();

  static Future<void> checkAndShowIfNeeded(BuildContext context) async {
    if (!context.mounted) return;

    var fetchOk = true;
    try {
      await FirebaseRemoteConfig.instance.fetchAndActivate();
    } catch (e, st) {
      fetchOk = false;
      AppLogger.w('Remote Config fetch (app update) failed', error: e, stackTrace: st);
    }

    final rc = FirebaseRemoteConfig.instance;
    final storeLink = rc.getString(RemoteConfigForceUpdateKeys.applicationStoreLink).trim();
    final currentRemote = rc.getString(RemoteConfigForceUpdateKeys.currentAppVersion).trim();
    final minSupported = rc.getString(RemoteConfigForceUpdateKeys.minimumSupportedAppVersion).trim();

    final info = await PackageInfo.fromPlatform();
    final installedRaw = info.version.trim();
    final installed = normalizeSemanticVersionString(info.version);

    final keysComplete = storeLink.isNotEmpty && currentRemote.isNotEmpty && minSupported.isNotEmpty;
    final vsCurrent = keysComplete ? compareSemanticVersions(installed, currentRemote) : null;
    final vsMin = keysComplete ? compareSemanticVersions(installed, minSupported) : null;

    String decision;
    if (!fetchOk && storeLink.isEmpty && currentRemote.isEmpty && minSupported.isEmpty) {
      decision = 'skip_no_rc_and_fetch_failed';
    } else if (storeLink.isEmpty || currentRemote.isEmpty || minSupported.isEmpty) {
      decision = 'skip_missing_rc_keys';
    } else {
      final uri = Uri.tryParse(storeLink);
      if (uri == null || !uri.hasScheme) {
        decision = 'skip_invalid_store_link';
      } else if (vsCurrent! >= 0) {
        decision = 'skip_app_up_to_date_or_newer_than_currentAppVersion';
      } else if (vsMin! < 0) {
        decision = 'show_dialog_force_update';
      } else {
        decision = 'show_dialog_optional_update';
      }
    }

    AppLogger.t(<String, dynamic>{
      'appUpdateCheck': 'MainScreen (after fetchAndActivate)',
      'fetchAndActivateOk': fetchOk,
      'packageInfoVersion': installedRaw,
      'packageInfoBuildNumber': info.buildNumber,
      'installedNormalizedForCompare': installed,
      RemoteConfigForceUpdateKeys.applicationStoreLink: storeLink,
      RemoteConfigForceUpdateKeys.currentAppVersion: currentRemote,
      RemoteConfigForceUpdateKeys.minimumSupportedAppVersion: minSupported,
      'cmpInstalledVsCurrentAppVersion': vsCurrent,
      'cmpInstalledVsMinimumSupported': vsMin,
      'cmpNote': '<0 installed older; 0 equal; >0 installed newer',
      'decision': decision,
    });

    if (storeLink.isEmpty || currentRemote.isEmpty || minSupported.isEmpty) {
      return;
    }

    final storeUri = Uri.tryParse(storeLink);
    if (storeUri == null || !storeUri.hasScheme) {
      AppLogger.w('Invalid APPLICATION_STORE_LINK: $storeLink');
      return;
    }

    if (compareSemanticVersions(installed, currentRemote) >= 0) {
      return;
    }

    final force = compareSemanticVersions(installed, minSupported) < 0;

    if (!context.mounted) return;

    await AppUpdatePromptScope.showDialogGuarded(context, () => showAppUpdateAvailableDialog(context, storeUri: storeUri, forceUpdate: force));
  }
}
