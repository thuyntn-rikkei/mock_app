import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/gen/assets.gen.dart';

///Use for Network Image
class CachedImageWidget extends StatelessWidget {
  final String url;
  final Alignment alignment;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusCustom;
  final BoxShape? shape;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;

  const CachedImageWidget({
    Key? key,
    required this.url,
    this.borderRadius,
    this.borderRadiusCustom,
    this.alignment = Alignment.topLeft,
    this.fit,
    this.shape,
    this.width,
    this.height,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: shape == null
              ? (borderRadiusCustom ?? BorderRadius.circular(borderRadius ?? 0))
              : null,
          shape: shape ?? BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      fit: BoxFit.cover,
      alignment: alignment,
      memCacheHeight: Config.memCacheHeight,
      memCacheWidth: Config.memCacheWidth,
      placeholder: (context, url) => SizedBox(
        height: height,
        width: width,
        child: const CupertinoActivityIndicator(),
      ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          SizedBox(
            height: height,
            width: width,
            child: Center(child: Assets.svg.icErrorHexagon.svg()),
          ),
    );
  }
}

CachedNetworkImageProvider cachedNetworkImageProvider(url) =>
    CachedNetworkImageProvider(
      url,
    );

class HighCachedImageWidget extends StatelessWidget {
  const HighCachedImageWidget({
    Key? key,
    required this.url,
    this.alignment = Alignment.topLeft,
    this.borderRadius,
    this.borderRadiusCustom,
    this.shape,
    this.fit,
    this.width,
    this.height,
    this.errorWidget,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
  }) : super(key: key);

  final String url;
  final Alignment alignment;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusCustom;
  final BoxShape? shape;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: shape == null
              ? (borderRadiusCustom ?? BorderRadius.circular(borderRadius ?? 0))
              : null,
          shape: shape ?? BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      fit: BoxFit.cover,
      alignment: alignment,
      memCacheHeight: maxHeightDiskCache == null ? Config.memCacheHeight : null,
      memCacheWidth: maxWidthDiskCache == null ? Config.memCacheWidth : null,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      placeholder: (context, url) => SizedBox(
        height: height,
        width: width,
        child: const CupertinoActivityIndicator(),
      ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          SizedBox(
            height: height,
            width: width,
            child: Center(child: Assets.svg.icErrorHexagon.svg()),
          ),
    );
  }
}
