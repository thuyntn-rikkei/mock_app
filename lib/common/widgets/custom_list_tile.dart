import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_bloc_3/common/index.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final EdgeInsets? padding;
  const CustomListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        children: [
          leading ?? const SizedBox.shrink(),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ?? AppStyles.s12w500,
                ),
                if (subTitle != null)
                  Padding(
                    padding: EdgeInsets.only(top: 2.0.h),
                    child: Text(
                      subTitle!,
                      style: subTitleStyle ??
                          AppStyles.s12w400.copyWith(
                            color: AppColors.deepDark.withOpacity(0.3),
                          ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
