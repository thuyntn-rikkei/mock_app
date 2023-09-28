import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/extensions/datetime_extension.dart';
import 'package:base_bloc_3/common/index.dart';

class TimePickerPopup extends StatefulWidget {
  final TimeOfDay initTime;
  final TimeOfDay? minTime;
  final Function(TimeOfDay?) onSelectedTime;

  const TimePickerPopup({
    super.key,
    required this.initTime,
    this.minTime,
    required this.onSelectedTime,
  });

  @override
  State<TimePickerPopup> createState() => _TimePickerPopupState();
}

class _TimePickerPopupState extends State<TimePickerPopup> {
  late TimeOfDay _selectedTime;
  final int precision = 5;

  @override
  void initState() {
    _selectedTime = widget.initTime.roundUp(precision: precision);
    super.initState();
  }

  void onIncreaseHour({bool isIncrease = true}) {
    if (isIncrease) {
      if (_selectedTime.hour < 23) {
        setState(() {
          _selectedTime = _selectedTime.replacing(
            hour: _selectedTime.hour + 1,
          );
        });
      }
    } else {
      if (_selectedTime.hour > 0 &&
          _selectedTime.hour > (widget.minTime?.hour ?? 0)) {
        setState(() {
          _selectedTime = _selectedTime.replacing(
            hour: _selectedTime.hour - 1,
          );
        });
      }
    }
  }

  void onIncreaseMinute({bool isIncrease = true}) {
    if (isIncrease) {
      if (_selectedTime.minute < 60 - precision) {
        setState(() {
          _selectedTime = _selectedTime.replacing(
            minute: _selectedTime.minute + precision,
          );
        });
      }
    } else {
      if (_selectedTime.minute > 0 &&
          (_selectedTime.hour == (widget.minTime?.hour ?? 0) &&
              _selectedTime.minute > (widget.minTime?.minute ?? 0))) {
        setState(() {
          _selectedTime = _selectedTime.replacing(
            minute: _selectedTime.minute - precision,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 36.h,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => onIncreaseHour(isIncrease: true),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      _selectedTime.hour.toString().padLeft(2, '0'),
                      style: AppStyles.s18w400,
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 36.h,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => onIncreaseHour(isIncrease: false),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Text(
                  ':',
                  style: AppStyles.s18w400,
                ),
                SizedBox(width: 10.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 36.h,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => onIncreaseMinute(isIncrease: true),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      _selectedTime.minute.toString().padLeft(2, '0'),
                      style: AppStyles.s18w400,
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 36.h,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => onIncreaseMinute(isIncrease: false),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                widget.onSelectedTime(_selectedTime);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
                child: Text(
                  'done'.tr(),
                  style: AppStyles.s16w500.copyWith(color: AppColors.alertLink),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
