import 'package:base_bloc_3/import.dart';

class PaymentBottomSheet extends StatefulWidget {
  final ValueNotifier isExpanded;
  final VoidCallback purchase;
  final VoidCallback enterDiscountCode;
  final VoidCallback applyDiscount;

  const PaymentBottomSheet({
    Key? key,
    required this.isExpanded,
    required this.purchase,
    required this.enterDiscountCode,
    required this.applyDiscount,
  }) : super(key: key);

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet>
    with TickerProviderStateMixin {
  late final isExpanded = widget.isExpanded..addListener(paymentDetail);
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _slideController;
  late final Animation<double> _sizeAnimation;
  late final AnimationController _sizeController;
  late Animation<double> _iconTurns;
  late final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _sizeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse) {
          Navigator.of(context).pop();
        }
      });
    _iconTurns = _sizeController.drive(
      Tween<double>(begin: 0.0, end: 0.5)
          .chain(CurveTween(curve: Curves.easeIn)),
    );
    _slideController.forward();
    _sizeController.forward();
  }

  void paymentDetail() {
    if (isExpanded.value) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) {
                _slideController.reverse();
              },
              child: Container(
                color: AppColors.deepDark.withOpacity(0.3),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return PositionedDirectional(
                bottom: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _modalContainer(
                    width: size.width,
                    padding: EdgeInsets.only(
                      top: 16.h,
                      bottom: 35.h,
                      left: 18.w,
                      right: 18.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizeTransition(
                          sizeFactor: _sizeAnimation,
                          axis: Axis.vertical,
                          axisAlignment: -1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              description(
                                leading: "amount".tr(),
                                trailing: "5",
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              description(
                                leading: "total_price".tr(),
                                trailing: 1099000.formatIntToPrice,
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              const Divider(thickness: 0.5),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Assets.svg.icBluePlus.svg(),
                            SizedBox(
                              width: 4.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showSelectCouponBottomSheet(
                                  context,
                                  size: size,
                                  enterDiscountCode: widget.enterDiscountCode,
                                );
                              },
                              child: Text(
                                "sale_code".tr(),
                                style: AppStyles.s14w400.copyWith(
                                  color: AppColors.alertLink,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                isExpanded.value = !isExpanded.value;
                              },
                              child: RotationTransition(
                                turns: _iconTurns,
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child: Assets.svg.icBlueArrowDown.svg(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            // todo dummy data
                            Text(
                              "provisional_price"
                                  .tr(namedArgs: {"price": "1.099.000"}),
                              style: AppStyles.s20w500.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.deepDark,
                          ),
                          child: Center(
                            child: Text(
                              "purchase".tr(),
                              style: AppStyles.s15w500.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Row description({required String leading, required String trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: AppStyles.s14w400.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          trailing,
          style: AppStyles.s14w400,
        ),
      ],
    );
  }

  Future<dynamic> _showSelectCouponBottomSheet(
    BuildContext context, {
    required Size size,
    required VoidCallback enterDiscountCode,
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          topLeft: Radius.circular(8.r),
        ),
      ),
      context: context,
      enableDrag: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.h,
            right: 14.w,
            left: 14.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Assets.svg.icClose.svg(),
                    ),
                    Text(
                      "discount_code".tr(),
                      style: AppStyles.s18w700,
                    ),
                    Assets.svg.icClose.svg(
                      colorFilter: const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 21.h,
                ),
                IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.deepDark, width: 0.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: _textController,
                            cursorColor: AppColors.deepDark,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 14.w,
                              ),
                              isCollapsed: true,
                              hintText: "enter_discount_code".tr(),
                              hintStyle: AppStyles.s14w300,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: enterDiscountCode,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.deepDark,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.r),
                                  bottomRight: Radius.circular(4.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "apply".tr(),
                                  style: AppStyles.s15w500.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),

                ///Todo component cua Tam lam
                Container(
                  height: 200.h,
                  color: AppColors.background,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h, bottom: 35.h),
                  child: AppButton(
                    onPressed: widget.applyDiscount,
                    verticalPadding: 12.h,
                    borderRadius: 8.r,
                    width: size.width,
                    title: "apply".tr(),
                    textStyle: AppStyles.s15w500.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _modalContainer({
    required double width,
    required Widget child,
    required EdgeInsetsGeometry padding,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: child,
    );
  }
}

Future<dynamic> showPaymentBottomSheet(
  BuildContext context, {
  required ValueNotifier isExpanded,
  required VoidCallback purchase,
  required VoidCallback enterDiscountCode,
  required VoidCallback applyDiscount,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (_, __, ___) {
        return PaymentBottomSheet(
          isExpanded: isExpanded,
          purchase: purchase,
          enterDiscountCode: enterDiscountCode,
          applyDiscount: applyDiscount,
        );
      },
    ),
  );
}
