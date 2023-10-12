import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/app_theme/app_colors.dart';
import 'package:base_bloc_3/common/widgets/shimmer/shimmer_widget.dart';

class ShimmerSelectionDiscountWidget extends StatelessWidget {
  const ShimmerSelectionDiscountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ShimmerWidget.rectangular(
                  height: 88.h,
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: Column(
                    children: [
                      ShimmerWidget.rectangular(
                        height: 40.h,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      ShimmerWidget.rectangular(
                        height: 14.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
