import 'package:base_bloc_3/import.dart';

/// Popup widget that you can use by default to show some information
class CustomSnackBarWidget extends StatefulWidget {
  final String message;
  final Widget icon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final int maxLines;
  final int iconRotationAngle;
  final List<BoxShadow> boxShadow;
  final BorderRadius borderRadius;
  final double iconPositionTop;
  final double iconPositionLeft;
  final EdgeInsetsGeometry messagePadding;
  final TextAlign textAlign;

  final TextScaler? textScaler;

  const CustomSnackBarWidget.success({
    super.key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.sentiment_very_satisfied,
      color: AppColors.silverFoil,
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = AppColors.alertSuccess,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.textAlign = TextAlign.center,
    this.textScaler,
  });

  const CustomSnackBarWidget.info({
    super.key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.sentiment_neutral,
      color: AppColors.silverFoil,
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xff2196F3),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textAlign = TextAlign.center,
    required this.textScaler,
  });

  const CustomSnackBarWidget.error({
    super.key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.error_outline,
      color: AppColors.silverFoil,
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = AppColors.alertError,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.textAlign = TextAlign.center,
    required this.textScaler,
  });

  @override
  CustomSnackBarWidgetState createState() => CustomSnackBarWidgetState();
}

class CustomSnackBarWidgetState extends State<CustomSnackBarWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: widget.boxShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: 1.sw,
      child: Row(
        children: [
          SizedBox(
            width: 16.w,
            height: 16.h,
            child: widget.icon,
          ),
          Expanded(
            child: Padding(
              padding: widget.messagePadding,
              child: Text(
                widget.message,
                style: theme.textTheme.bodyMedium?.merge(
                  widget.textStyle,
                ),
                textAlign: widget.textAlign,
                textScaler: widget.textScaler,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0.0, 8.0),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));
