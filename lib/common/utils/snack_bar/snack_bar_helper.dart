import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:injectable/injectable.dart';
import 'package:base_bloc_3/common/snack_bar_widget/snack_bar_widget.dart';

import 'package:base_bloc_3/gen/assets.gen.dart';
import 'package:base_bloc_3/common/index.dart';

enum SnackBarType { success, error, info }

@singleton
class SnackBarHelper {
  //todo: icon & color
  void _show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.success,
    int duration = Config.defaultDurationShowToast,
    Function()? onTap,
  }) async {
    Widget icon = const Icon(Icons.check);
    Color color = AppColors.alertSuccess;
    // haptic();
    switch (type) {
      case SnackBarType.success:
        icon = Assets.svg.icRoundChecked.svg();
        color = AppColors.alertSuccess;
        break;
      case SnackBarType.error:
        icon = const Icon(Icons.error_outline);
        color = AppColors.alertError;
        break;
      case SnackBarType.info:
        icon = const Icon(Icons.info_outline);
        color = Colors.blue;
        break;
    }
    SmartDialog.showToast(
      message,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 60.h, left: 16.w, right: 16.w),
          child: CustomSnackBarWidget.success(
            message: message,
            iconRotationAngle: 0,
            iconPositionLeft: 16.w,
            borderRadius: BorderRadius.circular(8.r),
            textStyle: AppStyles.s14w400.copyWith(color: Colors.white),
            backgroundColor: color,
            messagePadding: EdgeInsets.only(left: 16.w, right: 16.w, top: 0),
            textAlign: TextAlign.start,
            icon: icon,
          ),
        );
      },
      alignment: Alignment.topCenter,
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content:
    //     CustomSnackBarWidget.success(
    //       message: message,
    //       iconRotationAngle: 0,
    //       iconPositionLeft: 16.w,
    //       borderRadius: BorderRadius.circular(8.r),
    //       textStyle: AppStyles.s14w400.copyWith(color: Colors.white),
    //       backgroundColor: color,
    //       messagePadding: EdgeInsets.only(left: 16.w, right: 16.w, top: 0),
    //       textAlign: TextAlign.start,
    //       icon: icon,
    //     ),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: color,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8.r),
    //     ),
    //     duration: Duration(seconds: duration),
    //     padding: EdgeInsets.zero,
    //     margin: EdgeInsets.only(
    //       bottom: MediaQuery.of(context).size.height - 100.h,
    //       right: 16.w,
    //       left: 16.w,
    //     ),
    //   ),
    // );
  }

  dynamic showSuccess(
    BuildContext context,
    String message, {
    Function()? onTap,
  }) =>
      _show(
        context,
        message,
        onTap: onTap,
      );

  dynamic showInfo(
    BuildContext context,
    String message, {
    Function()? onTap,
  }) =>
      _show(
        context,
        message,
        onTap: onTap,
        type: SnackBarType.info,
      );

  dynamic showError(
    BuildContext context,
    String message, {
    int duration = Config.defaultDurationShowToast,
  }) =>
      _show(context, message, type: SnackBarType.error, duration: duration);
}
