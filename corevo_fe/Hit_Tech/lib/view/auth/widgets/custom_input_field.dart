import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

class CustomInputField extends StatefulWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final String? title;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool obscureText;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final Color? hintColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const CustomInputField({
    Key? key,
    this.width,
    this.height,
    this.hintText,
    this.title,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.hintColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
    required bool isPassword,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  late Animation<Color?> _colorAnimation;

  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _labelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.borderColor ?? AppColors.lighter,
      end: widget.focusedBorderColor ?? AppColors.bNormal,
    ).animate(_animationController);

    _focusNode.addListener(_onFocusChange);

    // Check if controller has initial text
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _hasText = true;
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused || _hasText) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChanged(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });

    if (_hasText || _isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height ?? AppDimensions.size64,
      child: Stack(
        children: [
          // Main TextFormField
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: _onTextChanged,
                onFieldSubmitted: widget.onSubmitted,
                obscureText: widget.obscureText,
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                style:
                    widget.textStyle ??
                    TextStyle(
                      fontSize: AppDimensions.textSizeM,
                      color: AppColors.dark,
                    ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.fillColor ?? AppColors.wWhite,
                  hintText: widget.title != null ? null : widget.hintText,
                  hintStyle:
                      widget.hintStyle ??
                      TextStyle(
                        color: widget.hintColor ?? AppColors.lighter,
                        fontSize: AppDimensions.textSizeM,
                      ),
                  suffixIcon: widget.suffixIcon,
                  contentPadding:
                      widget.contentPadding ??
                      const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? AppDimensions.borderRadius,
                    ),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? AppColors.lighter,
                      width: 1.5.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? AppDimensions.borderRadius,
                    ),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? AppColors.lighter,
                      width: 1.5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? AppDimensions.borderRadius,
                    ),
                    borderSide: BorderSide(
                      color: _colorAnimation.value ?? AppColors.bNormal,
                      width: 2.0.w,
                    ),
                  ),
                ),
              );
            },
          ),

          // Animated Label (only show if title is provided)
          if (widget.title != null)
            Positioned(
              left: AppDimensions.spacingM,
              child: AnimatedBuilder(
                animation: _labelAnimation,
                builder: (context, child) {
                  // Calculate position and scale based on animation
                  double yOffset = _labelAnimation.value * -27 + 20;
                  double scale =
                      1.0 -
                      (_labelAnimation.value * 0.25); // Scale from 1.0 to 0.75

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: _labelAnimation.value > 0.3
                            ? EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingS,
                              )
                            : EdgeInsets.zero,
                        decoration: _labelAnimation.value > 0.3
                            ? BoxDecoration(
                                color: widget.fillColor ?? AppColors.wWhite,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusTiny,
                                ),
                              )
                            : null,
                        child: Text(
                          widget.title!,
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeM,
                            color: _isFocused
                                ? (widget.focusedBorderColor ??
                                      AppColors.bNormal)
                                : (widget.hintColor ?? AppColors.lighter),
                            fontWeight:
                                _isFocused || (_labelAnimation.value > 0.5)
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
