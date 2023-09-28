import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:base_bloc_3/common/index.dart';

class ShimmerProductWidget extends StatelessWidget {
  final Color? baseColor;
  final double? shimmerImgHeight;
  final double? shimmerImgWidth;
  final double? shimmerTitleWidth;
  final double? shimmerDescriptionWidth;

  const ShimmerProductWidget({
    Key? key,
    this.baseColor,
    this.shimmerImgHeight,
    this.shimmerImgWidth,
    this.shimmerTitleWidth,
    this.shimmerDescriptionWidth,
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
            height: shimmerImgHeight ?? 219.h,
            width: shimmerImgWidth ?? 164.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            width: shimmerTitleWidth ?? 150.w,
            height: 17.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            width: shimmerDescriptionWidth ?? 80.w,
            height: 15.h,
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

//
// Shimmer getSaleItemShimmer() {
//   return Shimmer.fromColors(
//       baseColor: AppColors.background,
//       highlightColor: AppColors.background.withOpacity(0.3),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 160.h,
//             width: 120.w,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
//           ),
//           SizedBox(
//             height: 12.h,
//           ),
//           Container(
//             width: 100.w,
//             height: 17.h,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(2.r)),
//           ),
//           SizedBox(
//             height: 12.h,
//           ),
//           Container(
//             width: 100.w,
//             height: 15.h,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(2.r)),
//           ),
//           SizedBox(
//             height: 4.h,
//           ),
//           Container(
//             width: 60.w,
//             height: 15.h,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(2.r)),
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           Container(
//             width: 120.w,
//             height: 5.h,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(2.r)),
//           ),
//           SizedBox(
//             height: 4.h,
//           ),
//           Container(
//             width: 50.w,
//             height: 14.h,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(2.r)),
//           ),
//         ],
//       ));
// }
