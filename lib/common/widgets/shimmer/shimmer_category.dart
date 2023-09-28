import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:base_bloc_3/common/index.dart';

class ShimmerCategoryWidget extends StatelessWidget {
  final Color? baseColor;
  final double? shimmerSize;
  final double? shimmerTitleWidth;

  const ShimmerCategoryWidget({
    Key? key,
    this.baseColor,
    this.shimmerSize,
    this.shimmerTitleWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.white,
      highlightColor: (baseColor ?? AppColors.white).withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: shimmerSize ?? 90.h,
            width: shimmerSize ?? 90.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            width: shimmerTitleWidth ?? 90.w,
            height: 17.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}
