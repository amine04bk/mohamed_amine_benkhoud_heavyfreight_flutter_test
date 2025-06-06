import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/core/constants/app_colors.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/core/widgets/custom_button.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/features/package_form/presentation/screens/package_form_screen.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/features/driver/presentation/screens/driver_screen.dart';
import '../providers/auth_provider.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isDriver;

  const OTPScreen({required this.phoneNumber, this.isDriver = false, Key? key})
    : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _timerSeconds = 90; // Start from 01:30 (90 seconds)
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<TextEditingController> _otpControllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    startTimer();
    ref.read(authProvider.notifier).sendOTP(widget.phoneNumber);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String getTimerString() {
    final minutes = (_timerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showCheckPopup(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black54,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);

    String getOTP() {
      return _otpControllers.map((controller) => controller.text).join();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/mainbg.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryOrange,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'HeavyFreight',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  centerTitle: true,
                ),
                const Center(
                  child: Text(
                    'TRANSPORTATIONS',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color.fromARGB(255, 221, 221, 221),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 40,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Code sent to ${widget.phoneNumber}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please write the OTP code that we send to your\nregistered Email to complete your verification',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 30),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _animation.value,
                                child: OTPField(
                                  controllers: _otpControllers,
                                  onChanged: (index, value) {
                                    if (value.isNotEmpty && index < 3) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          AnimatedDefaultTextStyle(
                            style: const TextStyle(color: Colors.black54),
                            duration: const Duration(milliseconds: 300),
                            child: Text('Remaining Time: ${getTimerString()}'),
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Verify',
                            onPressed: () async {
                              _controller.reverse();
                              final otp = getOTP();
                              await authNotifier.verifyOTP(otp);
                              if (authState.isVerified) {
                                _showCheckPopup('Verification Successful!');
                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            widget.isDriver
                                                ? const DriverScreen()
                                                : const PackageFormScreen(),
                                  ),
                                );
                              } else {
                                _showCheckPopup('Invalid OTP, try again.');
                              }
                              _controller.forward();
                            },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed:
                                _timerSeconds > 0
                                    ? null
                                    : () {
                                      authNotifier.sendOTP(widget.phoneNumber);
                                      setState(() {
                                        _timerSeconds = 90;
                                        startTimer();
                                      });
                                      _showCheckPopup('OTP Resent!');
                                    },
                            child: Text(
                              _timerSeconds > 0
                                  ? "Didn't receive a code? Wait $_timerSeconds s"
                                  : "Didn't receive a code? RESEND",
                              style: TextStyle(
                                color:
                                    _timerSeconds > 0
                                        ? AppColors.textGrey
                                        : AppColors.primaryOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OTPField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final Function(int, String)? onChanged;

  const OTPField({required this.controllers, this.onChanged, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 50,
          height: 50,
          child: TextFormField(
            controller: controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppColors.primaryOrange),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: AppColors.primaryOrange,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (onChanged != null) onChanged!(index, value);
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        );
      }),
    );
  }
}
