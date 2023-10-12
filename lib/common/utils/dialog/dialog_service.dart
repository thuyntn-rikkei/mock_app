import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/gen/assets.gen.dart';

class DialogService {
  static bool isShowLoading = false;
  static bool isShowActionDialog = false;

  static Future<dynamic> showActionDialog(
    BuildContext context, {
    String? leftButtonText,
    String? rightButtonText,
    VoidCallback? onPressedLeftButton,
    VoidCallback? onPressedRightButton,
    String? description,
    TextStyle? descriptionTextStyle,
    TextStyle? leftButtonTextStyle,
    TextStyle? rightButtonTextStyle,
    bool callBackAfterClose = false,
    bool barrierDismissible = true,
    bool isOnlyDialog = false,
  }) {
    if (isShowActionDialog && isOnlyDialog) return Future.value();
    isShowActionDialog = true;
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => Future.value(barrierDismissible),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            child: DialogWidget(
              leftButtonTextStyle: leftButtonTextStyle,
              leftButtonText: leftButtonText,
              onPressedLeftButton: onPressedLeftButton,
              description: description,
              descriptionTextStyle: descriptionTextStyle,
              rightButtonText: rightButtonText,
              onPressedRightButton: onPressedRightButton,
              rightButtonTextStyle: rightButtonTextStyle,
              callBackAfterClose: callBackAfterClose,
            ),
          ),
        );
      },
    ).whenComplete(
      () => isShowActionDialog = false,
    );
  }

  static Future<dynamic> showLoading(BuildContext context) {
    if (isShowLoading) {
      return Future.value();
    }
    isShowLoading = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const LoadingWidget(),
        );
      },
    );
  }

  static hideDialog(BuildContext context) {
    if (!isShowLoading) {
      return Future.value();
    }
    isShowLoading = false;
    Navigator.of(context).pop();
  }

  static Future<dynamic> showSizeGuide(
    BuildContext context,
    String sizeGuide, {
    bool isOnlyDialog = false,
  }) {
    if (isShowActionDialog && isOnlyDialog) return Future.value();
    isShowActionDialog = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizeGuideDialog(
          content: sizeGuide,
        );
      },
    ).whenComplete(
      () => isShowActionDialog = false,
    );
  }

  static Future<dynamic> showPopUpHome(
    BuildContext context,
    String? title,
    String? content,
    String? img, {
    String? buttonLabel,
    bool isShowButton = false,
    bool isOnlyDialog = false,
    Function? onClickButton,
    bool isCouponPopup = false,
  }) {
    if (img == null) return Future.value();
    if (isShowActionDialog && isOnlyDialog) return Future.value();
    isShowActionDialog = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopUpHomeDialog(
          title: title,
          content: content,
          imgUrl: img,
          buttonLabel: buttonLabel,
          isShowButton: isShowButton,
          onClickButton: onClickButton,
          isCouponPopup: isCouponPopup,
        );
      },
    ).whenComplete(
      () => isShowActionDialog = false,
    );
  }

  static Future<dynamic> showCustomDialog(
    BuildContext context,
    Widget dialogUi, {
    bool isOnlyDialog = false,
  }) {
    if (isShowActionDialog && isOnlyDialog) return Future.value();
    isShowActionDialog = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return dialogUi;
      },
    ).whenComplete(
      () => isShowActionDialog = false,
    );
  }
}

class SizeGuideDialog extends StatelessWidget {
  const SizeGuideDialog({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        padding: EdgeInsets.only(left: 8.w),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 12.h, right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InteractiveViewer(
                    panEnabled: false, // Set it to false to prevent panning.
                    minScale: 1,
                    maxScale: 4,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      child: HtmlWidget(
                        content,
                        //set loading widget html
                        onLoadingBuilder: (context, element, loadingProcess) =>
                            const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Assets.svg.icCloseDialog.svg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopUpHomeDialog extends StatelessWidget {
  const PopUpHomeDialog({
    super.key,
    required this.title,
    required this.content,
    required this.imgUrl,
    required this.buttonLabel,
    required this.isShowButton,
    required this.onClickButton,
    required this.isCouponPopup,
  });

  final String? title;
  final String? content;
  final String imgUrl;
  final String? buttonLabel;
  final bool isShowButton;
  final Function? onClickButton;
  final bool isCouponPopup;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (!isCouponPopup) {
                      if (onClickButton != null) {
                        onClickButton!();
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: CachedImageWidget(
                    url: imgUrl,
                    fit: BoxFit.cover,
                    width: 1.sw,
                    height: 200.h,
                    borderRadiusCustom: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                  ),
                ),
                title == null && content == null
                    ? const SizedBox()
                    : SizedBox(height: 30.h),
                title != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          title ?? '',
                          style: AppStyles.s20w700,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(),
                content != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          content ?? '',
                          style: AppStyles.s15w400,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(),
                isShowButton && (buttonLabel?.isNotEmpty ?? false)
                    ? SizedBox(height: 50.h)
                    : const SizedBox(),
                isShowButton && (buttonLabel?.isNotEmpty ?? false)
                    ? Container(
                        height: 48.h,
                        width: 1.sw,
                        color: AppColors.background,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: AppButton(
                          title: buttonLabel!,
                          onPressed: () {
                            if (onClickButton != null) {
                              onClickButton!();
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    : const SizedBox(),
                title == null && content == null
                    ? const SizedBox()
                    : SizedBox(height: 20.h),
              ],
            ),
            Positioned(
              right: 10.w,
              top: 10.w,
              child: Container(
                height: 28.w,
                width: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.deepDark.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        color: Colors.transparent,
        child: SizedBox(
          width: 54.w,
          height: 54.h,
          child: Assets.images.loading.image(),
        ),
      ),
    );
  }
}

class DialogWidget extends StatefulWidget {
  final String? leftButtonText;
  final String? rightButtonText;
  final VoidCallback? onPressedLeftButton;
  final VoidCallback? onPressedRightButton;
  final String? description;
  final TextStyle? descriptionTextStyle;
  final TextStyle? leftButtonTextStyle;
  final TextStyle? rightButtonTextStyle;
  final bool callBackAfterClose;

  const DialogWidget({
    Key? key,
    this.leftButtonText,
    this.rightButtonText,
    this.onPressedLeftButton,
    this.onPressedRightButton,
    this.description,
    this.descriptionTextStyle,
    this.leftButtonTextStyle,
    this.rightButtonTextStyle,
    this.callBackAfterClose = false,
  }) : super(key: key);

  @override
  DialogWidgetState createState() => DialogWidgetState();
}

class DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.description != null
              ? Text(
                  widget.description ?? "",
                  textAlign: TextAlign.center,
                  style: widget.descriptionTextStyle ??
                      AppStyles.h4BodyText14ptRegular,
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 20,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    isOutlined: true,
                    verticalPadding: 0,
                    title: widget.leftButtonText ?? "OK",
                    onPressed: () {
                      if (widget.callBackAfterClose) {
                        Navigator.of(context).pop();
                        widget.onPressedLeftButton?.call();
                      } else {
                        widget.onPressedLeftButton?.call();
                        Navigator.of(context).pop();
                      }
                    },
                    borderRadius: 2,
                    textColor: AppColors.deepDark,
                    textStyle: widget.leftButtonTextStyle ??
                        AppStyles.button15ptMedium,
                  ),
                ),
                widget.rightButtonText != null
                    ? const SizedBox(
                        width: 16,
                      )
                    : const SizedBox.shrink(),
                widget.rightButtonText != null
                    ? Expanded(
                        child: AppButton(
                          verticalPadding: 0,
                          title: widget.rightButtonText ?? "",
                          onPressed: () {
                            widget.onPressedRightButton?.call();
                            Navigator.pop(context);
                          },
                          borderRadius: 2,
                          textStyle: widget.leftButtonTextStyle ??
                              AppStyles.button15ptMedium,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
