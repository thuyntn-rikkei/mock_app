import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:base_bloc_3/common/index.dart';

class ShimmerCategoryListWidget extends StatelessWidget {
  final Color? baseColor;
  final double? shimmerWidth;
  final int itemCount;

  const ShimmerCategoryListWidget({
    Key? key,
    this.baseColor,
    this.shimmerWidth,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.white,
      highlightColor: (baseColor ?? AppColors.white).withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            itemCount,
            (index) => Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Container(
                width: shimmerWidth ?? 120.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
