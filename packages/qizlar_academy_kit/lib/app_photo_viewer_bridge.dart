import 'package:flutter/material.dart';
import 'package:photo_viewer/photo_viewer.dart';

/// Ilova loyihasida `showPhotoViewer` analiz / import uchun: kit orqali chaqiring.
Future<void> showAppPhotoViewer({
  required BuildContext context,
  List<WidgetBuilder>? builders,
  WidgetBuilder? overlayBuilder,
  double? minScale,
  double? maxScale,
  String Function(int index)? heroTagBuilder,
  int initialPage = 0,
  bool showDefaultCloseButton = true,
  bool enableVerticalDismiss = true,
  ValueChanged<int>? onPageChanged,
  void Function(void Function(int page) jump)? onJumpToPage,
  BoxFit fit = BoxFit.cover,
  Widget Function(BuildContext, String)? placeholder,
  Widget Function(BuildContext, String, dynamic)? errorWidget,
}) {
  return showPhotoViewer(
    context: context,
    builders: builders,
    overlayBuilder: overlayBuilder,
    minScale: minScale,
    maxScale: maxScale,
    heroTagBuilder: heroTagBuilder,
    initialPage: initialPage,
    showDefaultCloseButton: showDefaultCloseButton,
    enableVerticalDismiss: enableVerticalDismiss,
    onPageChanged: onPageChanged,
    onJumpToPage: onJumpToPage,
    fit: fit,
    placeholder: placeholder,
    errorWidget: errorWidget,
  );
}
