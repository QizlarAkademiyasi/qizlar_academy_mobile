import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

@internal
bool hasUsablePaintRect(Rect rect) {
  return rect.left.isFinite &&
      rect.top.isFinite &&
      rect.right.isFinite &&
      rect.bottom.isFinite &&
      rect.width > 0 &&
      rect.height > 0;
}

@internal
bool hasUsableMatrix(Matrix4 matrix) {
  for (final value in matrix.storage) {
    if (!value.isFinite) {
      return false;
    }
  }
  return true;
}

@internal
bool hasUsableImageSize(Size size) {
  return size.width.isFinite &&
      size.height.isFinite &&
      size.width > 0 &&
      size.height > 0;
}

@internal
extension SnapRectToPixels on Rect {
  Rect snapToPixels(double devicePixelRatio) {
    return Rect.fromLTRB(
      left.snapToPixel(devicePixelRatio: devicePixelRatio),
      top.snapToPixel(devicePixelRatio: devicePixelRatio),
      right.snapToPixel(devicePixelRatio: devicePixelRatio),
      bottom.snapToPixel(devicePixelRatio: devicePixelRatio),
    );
  }
}

extension on double {
  double snapToPixel({required double devicePixelRatio}) {
    return (this * devicePixelRatio).roundToDouble() / devicePixelRatio;
  }
}
