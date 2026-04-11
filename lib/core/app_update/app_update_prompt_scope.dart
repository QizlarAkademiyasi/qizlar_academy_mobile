import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Bir vaqtning o‘zida bir nechta yangilanish dialoglarining ochilishini oldini oladi.
final class AppUpdatePromptScope {
  AppUpdatePromptScope._();

  static bool _dialogOpen = false;

  static Future<void> showDialogGuarded(BuildContext context, Future<void> Function() show) async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    try {
      await show();
    } finally {
      _dialogOpen = false;
    }
  }
}
