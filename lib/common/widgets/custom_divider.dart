import 'package:base_bloc_3/import.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
    this.thickness = 0.5,
    this.height = 0,
    this.color,
  }) : super(key: key);

  final double? thickness;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      height: height,
      color: color ?? AppColors.stroke,
    );
  }
}
