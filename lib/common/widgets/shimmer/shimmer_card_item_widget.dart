import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/app_theme/app_colors.dart';
import 'package:base_bloc_3/common/widgets/shimmer/shimmer_widget.dart';

class ShimmerCardItemWidget extends StatelessWidget {
  final Color? baseColor;

  const ShimmerCardItemWidget({Key? key, this.baseColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: baseColor ?? AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 12.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 50,
            child: ShimmerWidget.rectangular(
              height: 66.h,
            ),
          ),
          Expanded(
            flex: 310,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    height: 14.h,
                    width: 44.w,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  ShimmerWidget.rectangular(
                    height: 20.h,
                    width: 136.w,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  ShimmerWidget.rectangular(
                    height: 20.h,
                    width: 157.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ShimmerWidget.rectangular(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
