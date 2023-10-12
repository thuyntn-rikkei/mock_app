import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/gen/assets.gen.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String url;
  final double? radius;
  final String title;

  const CircleAvatarWidget({
    Key? key,
    required this.url,
    this.radius,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        url.isNotEmpty
            ? CachedImageWidget(
                url: url,
                width: (radius ?? 45.w) * 2,
                height: (radius ?? 45.w) * 2,
                shape: BoxShape.circle,
              )
            : SizedBox(
                width: (radius ?? 45.w) * 2,
                height: (radius ?? 45.w) * 2,
                child: Center(
                  child: Assets.svg.icImageDefault.svg(),
                ),
              ),
        SizedBox(
          height: 12.h,
        ),
        SizedBox(
          width: (radius ?? 45.w) * 2,
          child: Text(
            title,
            style: AppStyles.s13w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
