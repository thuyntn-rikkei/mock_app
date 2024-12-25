import 'package:base_bloc_3/import.dart';

class CustomDropDownButton extends StatelessWidget {
  final Function(int) onChangedCallback;
  final String title;
  final String type;
  final int? currentIndex;
  final Widget? icon;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final List<String> items;
  final int defaultIndex;

  const CustomDropDownButton({
    Key? key,
    required this.onChangedCallback,
    required this.title,
    this.currentIndex = 0,
    this.icon,
    this.borderRadius,
    this.borderWidth,
    this.padding,
    required this.items,
    required this.type,
    required this.defaultIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final int? res = await showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0.r)),
          ),
          context: context,
          builder: (c) => _Picker(
            items: items,
            currentItem: currentIndex ?? defaultIndex,
            type: type,
          ),
        );
        if (res != null) {
          onChangedCallback.call(res);
        }
      },
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.stroke),
          borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentIndex == null ? type : items.elementAt(currentIndex!),
                style: currentIndex == null
                    ? AppStyles.h5Input13ptLight
                        .copyWith(color: AppColors.deepDark.withOpacity(0.5))
                    : AppStyles.s14w400.copyWith(color: AppColors.deepDark),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.deepDark.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Picker extends StatefulWidget {
  final List<String> items;
  final int currentItem;
  final String type;

  const _Picker({
    Key? key,
    required this.items,
    required this.currentItem,
    required this.type,
  }) : super(key: key);

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  late FixedExtentScrollController controller;

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: widget.currentItem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh * 0.45,
      child: Column(
        children: [
          SizedBox(
            height: 8.h,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "${'choose_day'.tr()} ${widget.type}",
                style: AppStyles.s18w500,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, controller.selectedItem);
                    },
                    child: Text(
                      "ok".tr(),
                      style: AppStyles.button15ptMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: AppColors.stroke,
            height: 4.h,
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: ListWheelScrollView(
                itemExtent: 40,
                useMagnifier: true,
                magnification: 1.2,
                overAndUnderCenterOpacity: 0.5,
                controller: controller,
                perspective: 0.005,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (int index) {},
                diameterRatio: 1,
                children: widget.items
                    .map(
                      (e) => Text(
                        e,
                        style: AppStyles.s18w400,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
