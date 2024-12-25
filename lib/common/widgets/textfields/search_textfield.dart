import 'package:base_bloc_3/import.dart';

class CustomTextFieldSearch extends StatefulWidget {
  const CustomTextFieldSearch({
    Key? key,
    this.focusNode,
    this.searchTextController,
    this.onSearch,
    this.onChanged,
    this.backgroundColor,
    this.hintText,
    this.hintStyle,
    this.borderRadius,
    this.border,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.textStyle,
    this.iconSize = 24,
    this.boxConstaintHeight,
  }) : super(key: key);

  final Color? backgroundColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? border;
  final FocusNode? focusNode;
  final TextEditingController? searchTextController;
  final double? contentPaddingHorizontal;
  final Function(String)? onSearch;
  final Function(String)? onChanged;
  final double? contentPaddingVertical;
  final double? iconSize;
  final double? boxConstaintHeight;

  @override
  State<CustomTextFieldSearch> createState() => _CustomTextFieldSearchState();
}

class _CustomTextFieldSearchState extends State<CustomTextFieldSearch> {
  late TextEditingController _searchTextController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    _searchTextController =
        widget.searchTextController ?? TextEditingController();
    _searchTextController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: _searchTextController,
      style: widget.textStyle ?? AppStyles.s14w400,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: widget.contentPaddingVertical ?? 0,
          right: widget.contentPaddingVertical ?? 0,
          top: widget.contentPaddingVertical?.h ?? 8.h,
          bottom: widget.contentPaddingVertical?.h ?? 0,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.stroke,
            width: 1.0,
          ),
        ),
        isDense: true,
        fillColor: widget.backgroundColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 2,
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.stroke,
            width: 1.0,
          ),
        ),
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        filled: true,
        hintStyle: widget.hintStyle ??
            AppStyles.s14w400.copyWith(
              color: AppColors.deepDark.withOpacity(
                0.3,
              ),
            ),
        prefixIconConstraints: BoxConstraints(
          minWidth: widget.boxConstaintHeight ?? 24.w,
          maxWidth: widget.boxConstaintHeight ?? 24.w,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            Icons.search,
            size: widget.iconSize ?? 24,
          ),
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: 30.w,
          maxWidth: 30.w,
        ),
        suffixIcon: _searchTextController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  //clear text when tap icon clear
                  _searchTextController.text = '';
                  widget.onSearch?.call(_searchTextController.text.trim());
                },
                child: const Icon(Icons.close),
              )
            : const SizedBox(),
        hintText: widget.hintText ?? 'hint_input_search'.tr(),
      ),
      onChanged: (value) {
        widget.onChanged?.call(value.trim());
      },
      onSubmitted: (value) {
        widget.onSearch?.call(value.trim());
        _searchTextController.text = value.trim();
      },
    );
  }
}
