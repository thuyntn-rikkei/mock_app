import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/index.dart';

class EmptyListPage extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonTitle;
  final Widget iconWidget;

  const EmptyListPage({
    Key? key,
    required this.onPressed,
    required this.buttonTitle,
    required this.iconWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 38.w),
              child: iconWidget,
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
          Text('empty_list'.tr(), style: AppStyles.s15w500),
          SizedBox(
            height: 52.h,
          ),
          AppButton(
            verticalPadding: 14.h,
            title: buttonTitle,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class EmptyListWidget extends StatelessWidget {
  final Widget iconWidget;
  final String title;

  const EmptyListWidget({
    Key? key,
    required this.iconWidget,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          SizedBox(
            height: 22.h,
          ),
          Text(title, style: AppStyles.s15w400),
          SizedBox(
            height: 22.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: AppButton(
              title: "buy_now".tr(),
              onPressed: () {
                // redirect home screen
                // context.router.replaceAll([
                //   const CorePageRoute(),
                // ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
