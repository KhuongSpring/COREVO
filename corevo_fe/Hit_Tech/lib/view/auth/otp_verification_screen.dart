import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hit_tech/core/constants/app_message.dart';
import 'package:hit_tech/service/auth_service.dart';
import 'package:hit_tech/view/auth/reset_password_screen.dart';
import 'dart:async';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../model/request/auth/verify_otp_request.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final bool isRegister;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.isRegister,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _remainingTime = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String get _formattedTime {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onOtpDigitChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Auto verify when last digit is entered
        _verifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field when deleting
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onOtpDigitBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  bool _isOtpComplete() {
    return _getOtpCode().length == 6;
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete()) {
      _showMessage('Vui lòng nhập đầy đủ mã OTP', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = VerifyOtpRequest(email: widget.email, otp: _getOtpCode());

      if (widget.isRegister) {
        final response = await AuthService.verifyOtpToRegister(request);
        if (response.status) {
          _showMessage(AuthMessage.sucVerifyOtp);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          _showMessage(response.message ?? '', isError: true);
          _clearOtp();
        }
      } else {
        final response = await AuthService.verifyOtpToResetPassword(request);

        if (response.status) {
          _showMessage(AuthMessage.sucVerifyOtp);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: widget.email),
            ),
          );
        } else {
          _showMessage(response.message ?? '', isError: true);
        }
      }
    } catch (e) {
      _clearOtp();
      _showMessage(AuthMessage.errOtpInvalid, isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    if (_remainingTime > 0) return;

    setState(() {
      _isResending = true;
    });

    try {
      // Call resend OTP API here
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _showMessage('Mã OTP mới đã được gửi');
      _clearOtp();
      _startTimer();
    } catch (e) {
      _showMessage(
        'Không thể gửi lại mã OTP. Vui lòng thử lại.',
        isError: true,
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.authBackground,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.bNormal,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      if (widget.isRegister == false)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Quên mật khẩu",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: AppColors.dark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 32,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: index == 0 || index == 1
                                        ? AppColors.bNormal
                                        : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 40,
                    color: Colors.blue.shade600,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                const Text(
                  'Xác thực OTP',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  'Chúng tôi đã gửi mã xác thực 6 chữ số đến\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 48,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _controllers[index].text.isNotEmpty
                              ? Colors.blue.shade600
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bNormal,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.only(left: 3),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) =>
                                _onOtpDigitChanged(value, index),
                            onTap: () {
                              _controllers[index].selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _controllers[index].text.length,
                                    ),
                                  );
                            },
                          ).onKeyEvent(
                            onKey: (node, event) {
                              if (event is KeyUpEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.backspace) {
                                _onOtpDigitBackspace(index);
                              }
                              return KeyEventResult.ignored;
                            },
                          ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Timer and Resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gửi lại mã sau ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Resend Button
                TextButton(
                  onPressed: _remainingTime == 0 && !_isResending
                      ? _resendOtp
                      : null,
                  child: _isResending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Gửi lại mã OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _remainingTime == 0
                                ? Colors.blue.shade600
                                : Colors.grey.shade400,
                          ),
                        ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension TextFieldExtension on TextField {
  Widget onKeyEvent({
    required KeyEventResult Function(FocusNode, KeyEvent) onKey,
  }) {
    return Focus(onKeyEvent: onKey, child: this);
  }
}
