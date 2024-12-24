import 'package:base_bloc_3/import.dart';

class PageIndicator extends StatelessWidget {
  final int length;
  final int currentIndex;
  final Color? color;
  const PageIndicator({
    Key? key,
    required this.length,
    required this.currentIndex,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(microseconds: 500),
          height: 6.h,
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: color ?? AppColors.deepDark.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          width: index == currentIndex ? 24.w : 6.w,
        ),
      ),
    );
  }
}
