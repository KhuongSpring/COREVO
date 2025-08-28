import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

class UpdateProfilePopUp extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String type;

  const UpdateProfilePopUp({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onSave,
    required this.type,
  });

  @override
  State<UpdateProfilePopUp> createState() => _UpdateProfilePopUpState();
}

class _UpdateProfilePopUpState extends State<UpdateProfilePopUp> {
  final FocusNode _focusNode = FocusNode();
  late VoidCallback _textListener;

  @override
  void initState() {
    super.initState();

    _textListener = () {
      if (mounted) {
        setState(() {});
      }
    };

    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
    widget.controller.addListener(_textListener);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFocus = _focusNode.hasFocus;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: AppDimensions.width * 0.8.w,
          decoration: BoxDecoration(
            color: AppColors.wWhite,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          padding: EdgeInsets.only(
            top: AppDimensions.paddingM,
            left: AppDimensions.paddingM,
            right: AppDimensions.paddingM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.type,
                style: TextStyle(
                  fontSize: AppDimensions.textSizeS,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(height: AppDimensions.spacingSM),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                  border: Border.all(
                    color: isFocus || widget.controller.text.trim().isNotEmpty
                        ? AppColors.bNormal
                        : CupertinoColors.inactiveGray,
                    width: 1.w,
                  ),
                ),
                child: widget.type == 'Ngày sinh'
                    ? GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000, 1, 1),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (picked != null) {
                            final formatted = DateFormat(
                              'yyyy-MM-dd',
                            ).format(picked);
                            setState(() {
                              widget.controller.text = formatted;
                            });
                          }
                        },
                        child: AbsorbPointer(child: _buildTextField(false)),
                      )
                    : widget.type == 'Quốc tịch'
                    ? GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            countryListTheme: CountryListThemeData(
                              flagSize: AppDimensions.iconSizeXXL,
                              backgroundColor: AppColors.wWhite,
                              textStyle: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                color: AppColors.dark,
                              ),
                              searchTextStyle: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                color: AppColors.dark,
                              ),
                              bottomSheetHeight: AppDimensions.height * 0.5.w,
                              inputDecoration: InputDecoration(
                                prefixIconColor: AppColors.bNormal,
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.bNormal,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white38),
                                ),
                                focusColor: AppColors.bNormal,
                              ),
                            ),
                            onSelect: (Country country) {
                              setState(() {
                                widget.controller.text = country.name;
                              });
                            },
                          );
                        },
                        child: AbsorbPointer(child: _buildTextField(false)),
                      )
                    : widget.type == 'Số điện thoại'
                    ? _buildTextField(true)
                    : _buildTextField(false),
              ),
              SizedBox(height: AppDimensions.spacingL),
              Divider(height: 1.w, color: AppColors.bLightActive),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: widget.onCancel,
                      child: Text(
                        'Hủy bỏ',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: AppDimensions.textSizeS,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.size48,
                    child: VerticalDivider(
                      width: 1.w,
                      color: AppColors.bLightActive,
                    ),
                  ),
                  Expanded(
                    child: CupertinoButton(
                      onPressed: widget.controller.text.trim().isNotEmpty
                          ? widget.onSave
                          : null,
                      child: Text(
                        'Lưu',
                        style: TextStyle(
                          color: (widget.controller.text.trim().isNotEmpty)
                              ? AppColors.bNormal
                              : AppColors.lighter,
                          fontSize: AppDimensions.textSizeS,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(bool isPhone) {
    return CupertinoTextField(
      focusNode: _focusNode,
      controller: widget.controller,
      placeholder: 'Nhập ${widget.type.toLowerCase()}',
      clearButtonMode: OverlayVisibilityMode.editing,
      padding: EdgeInsets.all(AppDimensions.spacingSM),
      keyboardType: isPhone ? TextInputType.number : TextInputType.text,
      decoration: const BoxDecoration(),
      inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
    );
  }
}
