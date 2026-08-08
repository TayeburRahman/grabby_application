import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../src_export.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.inputFormatters,
    this.onFieldSubmitted,
    this.textEditingController,
    this.focusNode,
    this.titleStyle,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.cursorColor = AppColors.kTextColor,
    this.inputTextStyle,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.hintText = 'type here',
    this.hintStyle,
    this.suffixIcon,
    this.suffixIconColor,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLength,
    super.key,
    this.prefixIcon,
    this.onTap,
    this.isCollapsed,
    this.isDense,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.fillColor = Colors.white,
    this.borderColor,
    this.contentPadding = const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6
      // vertical: widget.maxLines! > 1 ? 12 : 12,
    ),
    this.title,
    this.isEnable = true,
    this.height,
    this.isRequired = false,
    this.borderRadius,
    this.minLines,
  });

  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final String? title;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color cursorColor;
  final TextStyle? inputTextStyle;
  final TextStyle? titleStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final double? borderRadius;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator? validator;
  final String? hintText;
  final TextStyle? hintStyle;

  final Color? suffixIconColor;
  final Color? fillColor;
  final Color? borderColor;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final OutlineInputBorder? border;

  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;

  final bool isPassword;
  final bool? isEnable;
  final bool? isRequired;
  final EdgeInsetsGeometry contentPadding;
  final bool readOnly;
  final double? height;
  final int? maxLength;
  final bool? isCollapsed;
  final bool? isDense;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap; // Callback function for onTap

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  final Color defaultFillColor = AppColors.kWhiteTextColor;
  final double defaultBorderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title != null
              ? Row(
                  children: [
                    Text(
                      widget.title ?? '',
                      style: widget.titleStyle ?? Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.kTextColor),
                    ),
                    widget.isRequired == true
                        ? CustomText('*', color: AppColors.kRedColor)
                        : const SizedBox.shrink(),
                  ],
                )
              : const SizedBox.shrink(),
          widget.title != null ? space8H : const SizedBox.shrink(),
          SizedBox(
            height: widget.height,
            child: TextFormField(
              textAlign: widget.textAlign,
              onTap: widget.onTap,
              enabled: widget.isEnable,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: widget.inputFormatters,
              onFieldSubmitted: widget.onFieldSubmitted,
              readOnly: widget.readOnly,
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              cursorColor: AppColors.kPrimaryColor,
              onTapOutside: (PointerDownEvent pointerDownEvent) => FocusScope.of(context).unfocus(),
              style: widget.inputTextStyle ?? Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.kTextColor),
              onChanged: widget.onChanged,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              obscureText: widget.isPassword ? obscureText : false,
              validator: (value) {
                final trimmedValue = value?.trim();
                if (widget.validator != null) {
                  return widget.validator!(trimmedValue);
                }
                if (widget.isRequired == true && (trimmedValue == null || trimmedValue.isEmpty)) {
                  return AppStaticStrings.required;
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: widget.contentPadding,
                fillColor: widget.fillColor ?? defaultFillColor,
                filled: true,
                isCollapsed: widget.isCollapsed,
                isDense: widget.isDense,
                errorMaxLines: 2,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.kTextColor.withValues(alpha: 0.5)),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: toggle,
                        child: obscureText
                            ? Icon(CupertinoIcons.eye_slash, size: 20, color: AppColors.kTextColor)
                            : Icon(CupertinoIcons.eye, size: 20, color: AppColors.kTextColor),
                      )
                    : widget.suffixIcon,
                suffixIconColor: widget.suffixIconColor ?? AppColors.kTextColor,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? defaultBorderRadius),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColors.kAccentColor,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? defaultBorderRadius),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColors.kAccentColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? defaultBorderRadius),
                  borderSide: BorderSide(
                    color: AppColors.kPrimaryColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? defaultBorderRadius),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColors.kAccentColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? defaultBorderRadius),
                  borderSide: const BorderSide(
                    color: AppColors.kRedColor,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? defaultBorderRadius),
                  borderSide: const BorderSide(
                    color: AppColors.kRedColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}