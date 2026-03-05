import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/firebase_options.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

Future<void> setupLocator() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppRemoteConfig.initialize();
}
