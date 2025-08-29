import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  static late double width;
  static late double height;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }

  // Spacing
  static double get spacingS => 8.w;

  static double get spacingSM => 12.w;

  static double get spacingM => 16.w;

  static double get spacingML => 20.w;

  static double get spacingL => 24.w;

  static double get spacingXL => 32.w;

  static double get spacingXXL => 40.w;

  static double get spacingXXXL => 48.w;

  static double get spacingHuge => 56.w;

  static double get spacingGiant => 64.w;

  // Padding
  static double get paddingXS => 4.w;

  static double get paddingS => 8.w;

  static double get paddingM => 16.w;

  static double get paddingL => 24.w;

  static double get paddingXL => 32.w;

  static double get paddingXXL => 40.w;

  static double get paddingXXXL => 48.w;

  // Text size
  static double get textSizeXS => 12.sp;

  static double get textSizeS => 14.sp;

  static double get textSizeM => 16.sp;

  static double get textSizeL => 20.sp;

  static double get textSizeXL => 24.sp;

  static double get textSizeXXL => 28.sp;

  static double get textSizeXXXL => 32.sp;

  // Icon Size

  static double get iconSizeXS => 12.sp;

  static double get iconSizeS => 14.sp;

  static double get iconSizeM => 16.sp;

  static double get iconSizeL => 20.sp;

  static double get iconSizeXL => 24.sp;

  static double get iconSizeXXL => 28.sp;

  static double get iconSizeXXXL => 32.sp;

  // Border radius
  static double get borderRadiusTiny => 4.r;

  static double get borderRadiusSmall => 10.r;

  static double get borderRadius => 12.r;

  static double get borderRadiusLarge => 28.r;

  // Overall Size
  static double get spacingWidthInfinite => double.infinity;

  static double get spacingHeightInfinite => double.infinity;

  static double get size4 => 4.w;

  static double get size8 => 8.w;

  static double get size16 => 16.w;

  static double get size24 => 24.w;

  static double get size32 => 32.w;

  static double get size40 => 40.w;

  static double get size48 => 48.w;

  static double get size56 => 56.w;

  static double get size64 => 64.w;

  static double get size72 => 72.w;

  static double get size80 => 80.w;

  static double get size88 => 88.w;

  static double get size96 => 96.w;

  static double get size104 => 104.w;

  static double get size112 => 112.w;

  static double get size120 => 120.w;

  static double get size128 => 128.w;

  static double get size136 => 136.w;

  static double get size144 => 144.w;

  static double get size152 => 152.w;

  static double get size160 => 160.w;

  static double get size168 => 168.w;

  static double get size176 => 176.w;

  static double get size184 => 184.w;

  static double get size192 => 192.w;

  static double get size200 => 200.w;

  static double get size208 => 208.w;

  static double get size216 => 216.w;

  static double get size224 => 224.w;

  static double get size232 => 232.w;

  static double get size240 => 240.w;

  static double get size248 => 248.w;

  static double get size256 => 256.w;

  static double get size264 => 264.w;

  static double get size272 => 272.w;

  static double get size280 => 280.w;

  static double get size288 => 288.w;

  static double get size296 => 296.w;

  static double get size304 => 304.w;

  static double get size312 => 312.w;

  static double get size320 => 320.w;

  static double get size328 => 328.w;

  static double get size336 => 336.w;

  static double get size344 => 344.w;

  static double get size352 => 352.w;

  static double get size360 => 360.w;

  static double get size368 => 368.w;

  static double get size376 => 376.w;

  static double get size384 => 384.w;

  static double get size392 => 392.w;

  static double get size400 => 400.w;

  // Height & Width
  static double get heightButton => 50.h;
}
