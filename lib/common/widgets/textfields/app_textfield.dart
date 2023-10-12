import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/index.dart';

import 'package:base_bloc_3/gen/assets.gen.dart';

enum TextFieldState {
  none,
  validateSucceeded,
  validateFailed,
  showMessage,
}

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double radius;
  final Color borderColor;
  final Color focusBorderColor;
  final Color? cursorColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? hintText;
  final String? initText;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final bool readOnly;
  final double paddingRightIcon;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final Color? bgChangeColor;
  final Color? borderChangeColor;
  final bool autofocus;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Widget in the bubble
  final Widget? messageContent;

  ///flag to show/ hide content in text field
  final bool isPassword;

  ///flag to determine state of text field
  final TextFieldState state;

  ///Error text below the text field
  final String? errorText;
  final int? maxLine;
  final int? maxLength;
  final bool isShowIconSucceeded;
  final bool isShowIconFailed;
  final List<FilteringTextInputFormatter>? listTextInputFormatter;

  /// Leading icon
  final Widget? leadingIcon;

  /// Input Action
  final TextInputAction? inputAction;

  const AppTextField({
    Key? key,
    this.controller,
    this.readOnly = false,
    this.radius = 8,
    this.borderColor = AppColors.stroke,
    this.focusBorderColor = AppColors.deepDark,
    this.textStyle,
    this.cursorColor,
    this.backgroundColor,
    this.hintText,
    this.hintStyle,
    this.isPassword = false,
    this.isShowIconSucceeded = true,
    this.isShowIconFailed = true,
    this.state = TextFieldState.none,
    this.errorText,
    this.messageContent,
    this.keyboardType,
    this.initText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.padding,
    this.maxLine = 1,
    this.maxLength,
    this.paddingRightIcon = 8,
    this.listTextInputFormatter,
    this.leadingIcon,
    this.bgChangeColor,
    this.borderChangeColor,
    this.inputAction,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  bool isObscure = false;
  bool isFocus = false;

  late TextStyle _textStyle;
  late TextFieldState _state;
  late FocusNode myFocusNode;

  @override
  void initState() {
    isObscure = widget.isPassword;
    _textStyle = widget.textStyle ?? AppStyles.h5Input13ptLight;
    _state = widget.state;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initText);
    myFocusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  void _toggleObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void _onFocusChange(bool val) {
    setState(() {
      isFocus = val;
    });
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != _state) {
      setState(() {
        _state = widget.state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myFocusNode.requestFocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isFocus
                  ? (widget.bgChangeColor ?? widget.backgroundColor)
                  : widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color: _borderColor,
              ),
            ),
            padding: widget.padding ??
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            child: Row(
              children: [
                if (widget.leadingIcon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: widget.leadingIcon!,
                  ),
                Expanded(
                  child: Focus(
                    onFocusChange: _onFocusChange,
                    child: TextField(
                      focusNode: myFocusNode,
                      inputFormatters: widget.listTextInputFormatter,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      readOnly: widget.readOnly,
                      cursorColor: widget.cursorColor ?? Colors.black,
                      obscureText: isObscure,
                      obscuringCharacter: '●',
                      autofocus: widget.autofocus,
                      maxLength: widget.maxLength,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLine,
                      textInputAction: widget.inputAction,
                      scrollPadding: EdgeInsets.zero,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        isCollapsed: true,
                        hintText: widget.hintText ?? "",
                        hintStyle: widget.hintStyle ??
                            AppStyles.h5Input13ptLight.copyWith(
                              color: AppColors.deepDark.withOpacity(0.5),
                            ),
                      ),
                      style: _textStyle.copyWith(color: _textColor),
                      controller: _controller,
                    ),
                  ),
                ),
                if (_state == TextFieldState.validateSucceeded)
                  if (widget.isShowIconSucceeded)
                    Padding(
                      padding:
                          EdgeInsets.only(right: widget.paddingRightIcon.w),
                      child: Assets.svg.icDone.svg(),
                    ),
                if (_state == TextFieldState.validateFailed && !isFocus)
                  if (widget.isShowIconFailed)
                    Padding(
                      padding:
                          EdgeInsets.only(right: widget.paddingRightIcon.w),
                      child: Assets.svg.icError.svg(),
                    ),
                if (widget.isPassword)
                  InkWell(
                    onTap: _toggleObscure,
                    child: isObscure
                        ? Assets.svg.icEye.svg()
                        : Assets.svg.icEyeOff.svg(),
                  ),
              ],
            ),
          ),
          if ((widget.errorText ?? "").isNotEmpty &&
              _state == TextFieldState.validateFailed &&
              !isFocus)
            Padding(
              padding: EdgeInsets.only(top: 8.0.h),
              child: Text(
                widget.errorText!,
                style: AppStyles.h612ptRegular
                    .copyWith(color: AppColors.alertError),
              ),
            ),
          if (_state == TextFieldState.showMessage)
            MessageBubble(
              onTapClose: () {
                setState(() {
                  _state = TextFieldState.none;
                });
              },
              child: widget.messageContent ?? const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  Color get _borderColor {
    if (_state == TextFieldState.validateFailed && !isFocus) {
      return AppColors.alertError;
    }
    if (_state == TextFieldState.showMessage) {
      return AppColors.brandingOwen;
    }
    if (isFocus) {
      return widget.focusBorderColor;
    } else {
      return isFocus
          ? (widget.borderChangeColor ?? widget.borderColor)
          : widget.borderColor;
    }
  }

  Color get _textColor {
    if (_state == TextFieldState.validateFailed && !isFocus) {
      return AppColors.alertError;
    }
    return _textStyle.color ?? AppColors.deepDark;
  }
}

class MessageBubble extends StatelessWidget {
  final Widget child;
  final Function() onTapClose;

  const MessageBubble({
    Key? key,
    required this.child,
    required this.onTapClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: CustomPaint(
        painter: BubblePainter(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    child,
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: onTapClose,
              child: Padding(
                padding: EdgeInsets.only(top: 14.0.h, right: 2.w),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
