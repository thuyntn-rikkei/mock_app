import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/app_theme/app_colors.dart';
import 'package:base_bloc_3/common/app_theme/app_text_styles.dart';
import 'package:base_bloc_3/gen/assets.gen.dart';

class LeadingItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final VoidCallback? onTap;
  final int? badge;
  final bool hasArrowIcon;

  const LeadingItem({
    Key? key,
    required this.leading,
    required this.title,
    this.onTap,
    this.badge,
    this.hasArrowIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 18.h),
        child: Row(
          children: [
            leading,
            SizedBox(
              width: 16.w,
            ),
            Expanded(child: title),
            Row(
              children: [
                badge != null && badge! > 0
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 4.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.alertError,
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        child: Center(
                          child: Text(
                            badge! > 9 ? "9+" : badge.toString(),
                            style: AppStyles.s12w500.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  width: 6.w,
                ),
                hasArrowIcon ? Assets.svg.icArrowRight.svg() : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
