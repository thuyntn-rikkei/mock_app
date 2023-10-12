import 'package:flutter/material.dart';
import 'package:base_bloc_3/common/app_theme/app_colors.dart';

class LineSeparator extends StatelessWidget {
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const LineSeparator({Key? key, this.height = 1, this.color, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 0, left: 0),
      height: height,
      color: color ?? AppColors.background,
    );
  }
}
