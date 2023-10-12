import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/index.dart';

class DateTimePickerTextField extends StatelessWidget {
  final Function()? onTap;
  final Widget? prefixIcon;
  final String? value;
  final String? hintText;

  const DateTimePickerTextField({
    super.key,
    this.onTap,
    this.prefixIcon,
    this.value,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.stroke),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        child: Row(
          children: [
            prefixIcon ?? const SizedBox(),
            if (prefixIcon != null) SizedBox(width: 12.w),
            Expanded(
              child: Text(
                value ?? hintText ?? "",
                style: AppStyles.h4BodyText14ptRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
