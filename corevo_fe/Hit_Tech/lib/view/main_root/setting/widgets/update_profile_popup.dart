import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:intl/intl.dart';

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
          width: MediaQuery.of(context).size.width.sp * 0.8.sp,
          decoration: BoxDecoration(
            color: AppColors.wWhite,
            borderRadius: BorderRadius.circular(15.sp),
          ),
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isFocus || widget.controller.text.trim().isNotEmpty
                        ? AppColors.bNormal
                        : CupertinoColors.inactiveGray,
                    width: 1,
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
                        child: AbsorbPointer(child: _buildTextField()),
                      )
                    : _buildTextField(),
              ),
              SizedBox(height: 25.sp),
              const Divider(height: 1, color: AppColors.bLightActive),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: widget.onCancel,
                      child: const Text(
                        'Hủy bỏ',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.sp,
                    child: const VerticalDivider(
                      width: 1,
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
                              : Colors.grey,
                          fontSize: 14,
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

  Widget _buildTextField() {
    return CupertinoTextField(
      focusNode: _focusNode,
      controller: widget.controller,
      placeholder: 'Nhập ${widget.type.toLowerCase()}',
      clearButtonMode: OverlayVisibilityMode.editing,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(),
    );
  }
}
