import 'package:flutter/widgets.dart';

abstract class AppMargin {
  AppMargin._();

  /// 0px
  static const EdgeInsets marginZero = EdgeInsets.zero;

  /// 4px
  static const EdgeInsets margin2xs = EdgeInsets.all(4);

  /// 8px
  static const EdgeInsets marginXs = EdgeInsets.all(8);

  /// 12px
  static const EdgeInsets marginSm = EdgeInsets.all(12);

  /// 16px
  static const EdgeInsets marginMd = EdgeInsets.all(16);

  /// 20px
  static const EdgeInsets marginLg = EdgeInsets.all(20);

  /// 24px
  static const EdgeInsets marginXl = EdgeInsets.all(24);

  /// 8px (horizontal)
  static const EdgeInsets marginHorizontalXs = EdgeInsets.symmetric(
    horizontal: 8,
  );

  /// 12px (horizontal)
  static const EdgeInsets marginHorizontalSm = EdgeInsets.symmetric(
    horizontal: 12,
  );

  /// 16px (horizontal)
  static const EdgeInsets marginHorizontalMd = EdgeInsets.symmetric(
    horizontal: 16,
  );

  /// 20px (horizontal)
  static const EdgeInsets marginHorizontalLg = EdgeInsets.symmetric(
    horizontal: 20,
  );

  /// 24px (horizontal)
  static const EdgeInsets marginHorizontalXl = EdgeInsets.symmetric(
    horizontal: 24,
  );

  /// 8px (vertical)
  static const EdgeInsets marginVerticalXs = EdgeInsets.symmetric(vertical: 8);

  /// 12px (vertical)
  static const EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: 12);

  /// 16px (vertical)
  static const EdgeInsets marginVerticalMd = EdgeInsets.symmetric(vertical: 16);

  /// 20px (vertical)
  static const EdgeInsets marginVerticalLg = EdgeInsets.symmetric(vertical: 20);

  /// 24px (vertical)
  static const EdgeInsets marginVerticalXl = EdgeInsets.symmetric(vertical: 24);

  /// 8px (top)
  static const EdgeInsets marginTopXs = EdgeInsets.only(top: 8);

  /// 12px (top)
  static const EdgeInsets marginTopSm = EdgeInsets.only(top: 12);

  /// 16px (top)
  static const EdgeInsets marginTopMd = EdgeInsets.only(top: 16);

  /// 20px (top)
  static const EdgeInsets marginTopLg = EdgeInsets.only(top: 20);

  /// 24px (top)
  static const EdgeInsets marginTopXl = EdgeInsets.only(top: 24);

  /// 8px (bottom)
  static const EdgeInsets marginBottomXs = EdgeInsets.only(bottom: 8);

  /// 12px (bottom)
  static const EdgeInsets marginBottomSm = EdgeInsets.only(bottom: 12);

  /// 16px (bottom)
  static const EdgeInsets marginBottomMd = EdgeInsets.only(bottom: 16);

  /// 20px (bottom)
  static const EdgeInsets marginBottomLg = EdgeInsets.only(bottom: 20);

  /// 24px (bottom)
  static const EdgeInsets marginBottomXl = EdgeInsets.only(bottom: 24);

  /// 8px (left)
  static const EdgeInsets marginLeftXs = EdgeInsets.only(left: 8);

  /// 12px (left)
  static const EdgeInsets marginLeftSm = EdgeInsets.only(left: 12);

  /// 16px (left)
  static const EdgeInsets marginLeftMd = EdgeInsets.only(left: 16);

  /// 20px (left)
  static const EdgeInsets marginLeftLg = EdgeInsets.only(left: 20);

  /// 24px (left)
  static const EdgeInsets marginLeftXl = EdgeInsets.only(left: 24);

  /// 8px (right)
  static const EdgeInsets marginRightXs = EdgeInsets.only(right: 8);

  /// 12px (right)
  static const EdgeInsets marginRightSm = EdgeInsets.only(right: 12);

  /// 16px (right)
  static const EdgeInsets marginRightMd = EdgeInsets.only(right: 16);

  /// 20px (right)
  static const EdgeInsets marginRightLg = EdgeInsets.only(right: 20);

  /// 24px (right)
  static const EdgeInsets marginRightXl = EdgeInsets.only(right: 24);

  /// 20px (horizontal)
  static const EdgeInsets pageHorizontal = marginHorizontalLg;

  /// Home: guest card margin
  static const EdgeInsets homeGuestCard = pageHorizontal;
}
