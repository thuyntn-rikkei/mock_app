import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:base_bloc_3/common/app_theme/index.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    required this.shapeBorder,
    this.baseColor,
    this.highlightColor,
  });

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.baseColor,
    this.highlightColor,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: baseColor ?? AppColors.white,
        highlightColor: (baseColor ?? AppColors.white).withOpacity(0.3),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[300]!,
            shape: shapeBorder,
          ),
        ), // ContainerI
      ); // Shimmer.fromColors
}
