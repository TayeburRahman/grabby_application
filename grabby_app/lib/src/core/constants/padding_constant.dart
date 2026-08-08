import 'package:flutter/material.dart';

class AppPadding {
  static bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1300;

  static EdgeInsets getPadding16(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 24 : 16);

  static EdgeInsets getPadding24(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 32 : 24);

  static EdgeInsets getPadding12(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 16 : 12);

  static EdgeInsets getPadding10(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 14 : 10);

  static EdgeInsets getPadding8(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 12 : 8);

  static EdgeInsets getPadding6(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 10 : 6);

  static EdgeInsets getPadding4(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 8 : 4);

  static EdgeInsets getPadding2(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 4 : 2);

  static EdgeInsets getPadding4V(BuildContext context) =>
      EdgeInsets.symmetric(vertical: _isDesktop(context) ? 8 : 4);

  static EdgeInsets getPadding14(BuildContext context) =>
      EdgeInsets.all(_isDesktop(context) ? 18 : 14);

  static EdgeInsets getPadding16H(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: _isDesktop(context) ? 24 : 16);

  static EdgeInsets getPadding12T(BuildContext context) =>
      EdgeInsets.only(top: _isDesktop(context) ? 16 : 12);

  static EdgeInsets getPadding6T(BuildContext context) =>
      EdgeInsets.only(top: _isDesktop(context) ? 10 : 6);

  static EdgeInsets getPadding16V(BuildContext context) =>
      EdgeInsets.symmetric(vertical: _isDesktop(context) ? 24 : 16);

  static EdgeInsets getPadding14H(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: _isDesktop(context) ? 18 : 14);

  static EdgeInsets getPadding14V(BuildContext context) =>
      EdgeInsets.symmetric(vertical: _isDesktop(context) ? 18 : 14);

  static EdgeInsets getPadding12H(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: _isDesktop(context) ? 16 : 12);

  static EdgeInsets getPadding12V(BuildContext context) =>
      EdgeInsets.symmetric(vertical: _isDesktop(context) ? 16 : 12);

  static EdgeInsets getPadding6H(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: _isDesktop(context) ? 10 : 6);

  static EdgeInsets getPadding6V(BuildContext context) =>
      EdgeInsets.symmetric(vertical: _isDesktop(context) ? 10 : 6);

  static EdgeInsets getPadding16b24(BuildContext context) => EdgeInsets.only(
    left: _isDesktop(context) ? 24 : 16,
    right: _isDesktop(context) ? 24 : 16,
    top: _isDesktop(context) ? 24 : 16,
    bottom: _isDesktop(context) ? 32 : 24,
  );

  static EdgeInsets getPaddingH12V6(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 16 : 12,
        vertical: _isDesktop(context) ? 10 : 6,
      );

  static EdgeInsets getPaddingH8V4(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 12 : 8,
        vertical: _isDesktop(context) ? 8 : 4,
      );

  static EdgeInsets getPaddingH12V8(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 16 : 12,
        vertical: _isDesktop(context) ? 12 : 8,
      );

  static EdgeInsets getPaddingH12V4(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 16 : 12,
        vertical: _isDesktop(context) ? 8 : 4,
      );

  static EdgeInsets getPaddingH16V2(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 24 : 16,
        vertical: _isDesktop(context) ? 4 : 2,
      );

  static EdgeInsets getPaddingH16V8(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 24 : 16,
        vertical: _isDesktop(context) ? 12 : 8,
      );
}
