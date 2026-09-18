import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/src/internal/snap_rect_to_pixels.dart';

void main() {
  test('hasUsableImageSize rejects Infinity, NaN and empty sizes', () {
    expect(hasUsableImageSize(const Size(44, 44)), isTrue);
    expect(hasUsableImageSize(Size.zero), isFalse);
    expect(hasUsableImageSize(const Size(-1, 44)), isFalse);
    expect(hasUsableImageSize(const Size(double.infinity, 44)), isFalse);
    expect(hasUsableImageSize(const Size(44, double.negativeInfinity)), isFalse);
    expect(hasUsableImageSize(const Size(double.nan, 44)), isFalse);
  });

  test('hasUsablePaintRect rejects non-finite PageView transforms', () {
    expect(hasUsablePaintRect(const Rect.fromLTWH(0, 0, 379.4, 44)), isTrue);
    expect(
      hasUsablePaintRect(
        const Rect.fromLTRB(
          double.negativeInfinity,
          0,
          double.infinity,
          44,
        ),
      ),
      isFalse,
    );
    expect(
      hasUsablePaintRect(Rect.fromLTWH(double.nan, 0, 44, 44)),
      isFalse,
    );
  });

  test('hasUsableMatrix rejects NaN and Infinity storage', () {
    expect(hasUsableMatrix(Matrix4.identity()), isTrue);
    expect(hasUsableMatrix(Matrix4.translationValues(-390, 0, 0)), isTrue);

    final infinite = Matrix4.identity()..setEntry(0, 3, double.infinity);
    expect(hasUsableMatrix(infinite), isFalse);

    final nan = Matrix4.identity()..setEntry(1, 1, double.nan);
    expect(hasUsableMatrix(nan), isFalse);
  });
}
