import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

mixin PrivacyPolicyScreenMixin<T extends StatefulWidget> on State<T> {
  /// Orqaga — [AppBackButton] ichida allaqachon [Gaimon] chaqiriladi.
  void onPrivacyPolicyBackTap(BuildContext context) => context.pop();
}
