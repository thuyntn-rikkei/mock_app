import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_bloc_3/common/app_theme/app_colors.dart';
import 'package:base_bloc_3/common/app_theme/app_text_styles.dart';

import 'package:base_bloc_3/common/bottom_sheet/line_separation.dart';

/// [AppContentSheet] is a simple bottom sheet to show any content which is a widget
/// if content is a list, consider to use [AppDragableBottomSheet]
class AppContentSheet extends StatefulWidget {
  final String title;
  final Widget content;
  final bool enableDrag;
  final VoidCallback? onClose;
  final double minHeightRatio;
  final double maxHeightRatio;
  final double initialHeightRatio;

  const AppContentSheet({
    super.key,
    required this.title,
    required this.content,
    this.enableDrag = false,
    this.onClose,
    this.minHeightRatio = 0.3,
    this.maxHeightRatio = 0.9,
    this.initialHeightRatio = 0.8,
  });

  @override
  State<AppContentSheet> createState() => _AppContentSheetState();

  Future show(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return this;
      },
    );
  }
}

class _AppContentSheetState extends State<AppContentSheet> {
  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    assert(
      widget.content is! SingleChildScrollView,
      'The content of [AppContentSheet] must not be [SingleChildScrollView], please use other widget',
    );

    return DraggableScrollableSheet(
      minChildSize: widget.minHeightRatio,
      maxChildSize: widget.maxHeightRatio,
      initialChildSize: widget.initialHeightRatio,
      expand: false,
      builder: (context, scrollController) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 13.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: AppStyles.s18w700,
                  ),
                ),
              ),
              SizedBox(
                height: 5.w,
              ),
              const LineSeparator(
                margin: EdgeInsets.zero,
              ),
              SizedBox(
                height: 4.w,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: widget.content,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
