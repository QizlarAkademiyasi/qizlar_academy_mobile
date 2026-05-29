import FirebaseCore
import FirebaseMessaging
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase ichki logi default `.notice` — shu darajada FCM swizzling haqidagi [I-FCM001000] chiqadi.
    // Flutter uchun swizzling o‘chirilmasligi kerak; bu yerda faqat konsol shovqinini kamaytiramiz.
    FirebaseConfiguration.shared.setLoggerLevel(.warning)
    let ok = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    DispatchQueue.main.async {
      application.registerForRemoteNotifications()
    }
    return ok
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  /// FCM: swizzling ba’zan APNS tokenni Messaging ga yetkazmasa, Flutter [getAPNSToken] `null` bo‘lishi mumkin.
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog("Runner: APNs ro‘yxatdan o‘tish xatosi: \(error.localizedDescription)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}
