import 'package:flutter/widgets.dart';

abstract class AppPadding {
  AppPadding._();

  /// 0px
  static const EdgeInsets paddingZero = EdgeInsets.zero;

  /// 4px
  static const EdgeInsets padding2xs = EdgeInsets.all(4);

  /// 8px
  static const EdgeInsets paddingXs = EdgeInsets.all(8);

  /// 12px
  static const EdgeInsets paddingSm = EdgeInsets.all(12);

  /// 16px
  static const EdgeInsets paddingMd = EdgeInsets.all(16);

  /// 20px
  static const EdgeInsets paddingLg = EdgeInsets.all(20);

  /// 24px
  static const EdgeInsets paddingXl = EdgeInsets.all(24);

  /// 8px (horizontal)
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(
    horizontal: 8,
  );

  /// 12px (horizontal)
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: 12,
  );

  /// 16px (horizontal)
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: 16,
  );

  /// 20px (horizontal)
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: 20,
  );

  /// 24px (horizontal)
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: 24,
  );

  /// 8px (vertical)
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: 8);

  /// 12px (vertical)
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: 12);

  /// 16px (vertical)
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: 16);

  /// 20px (vertical)
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: 20);

  /// 24px (vertical)
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: 24);

  /// 8px (top)
  static const EdgeInsets paddingTopXs = EdgeInsets.only(top: 8);

  /// 12px (top)
  static const EdgeInsets paddingTopSm = EdgeInsets.only(top: 12);

  /// 16px (top)
  static const EdgeInsets paddingTopMd = EdgeInsets.only(top: 16);

  /// 20px (top)
  static const EdgeInsets paddingTopLg = EdgeInsets.only(top: 20);

  /// 24px (top)
  static const EdgeInsets paddingTopXl = EdgeInsets.only(top: 24);

  /// 8px (bottom)
  static const EdgeInsets paddingBottomXs = EdgeInsets.only(bottom: 8);

  /// 12px (bottom)
  static const EdgeInsets paddingBottomSm = EdgeInsets.only(bottom: 12);

  /// 16px (bottom)
  static const EdgeInsets paddingBottomMd = EdgeInsets.only(bottom: 16);

  /// 20px (bottom)
  static const EdgeInsets paddingBottomLg = EdgeInsets.only(bottom: 20);

  /// 24px (bottom)
  static const EdgeInsets paddingBottomXl = EdgeInsets.only(bottom: 24);

  /// 8px (left)
  static const EdgeInsets paddingLeftXs = EdgeInsets.only(left: 8);

  /// 12px (left)
  static const EdgeInsets paddingLeftSm = EdgeInsets.only(left: 12);

  /// 16px (left)
  static const EdgeInsets paddingLeftMd = EdgeInsets.only(left: 16);

  /// 20px (left)
  static const EdgeInsets paddingLeftLg = EdgeInsets.only(left: 20);

  /// 24px (left)
  static const EdgeInsets paddingLeftXl = EdgeInsets.only(left: 24);

  /// 8px (right)
  static const EdgeInsets paddingRightXs = EdgeInsets.only(right: 8);

  /// 12px (right)
  static const EdgeInsets paddingRightSm = EdgeInsets.only(right: 12);

  /// 16px (right)
  static const EdgeInsets paddingRightMd = EdgeInsets.only(right: 16);

  /// 20px (right)
  static const EdgeInsets paddingRightLg = EdgeInsets.only(right: 20);

  /// 24px (right)
  static const EdgeInsets paddingRightXl = EdgeInsets.only(right: 24);

  /// Home: guest card inner padding (24px)
  static const EdgeInsets homeGuestCard = paddingXl;

  /// Home: guest button padding (h:28, v:12)
  static const EdgeInsets homeGuestButton = EdgeInsets.symmetric(
    horizontal: 28,
    vertical: 12,
  );
}
