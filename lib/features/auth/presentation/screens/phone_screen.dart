import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/core/constants/app_colors.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/core/widgets/custom_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../providers/auth_provider.dart';
import 'otp_screen.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  final bool isDriver;

  const PhoneScreen({Key? key, this.isDriver = false}) : super(key: key);

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  String fullPhoneNumber = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset('assets/mainbg.jpg', fit: BoxFit.cover),
          ),

          // Foreground content
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

                // Expanded white container
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
                            'Enter Your Phone Number',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Please enter your registered phone number to receive a one-time password (OTP) for verification.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),

                          // Country Code Picker Field
                          IntlPhoneField(
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            initialCountryCode: 'TN',
                            onChanged: (phone) {
                              fullPhoneNumber = phone.completeNumber;
                            },
                          ),

                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Send OTP Code',
                            onPressed: () {
                              if (fullPhoneNumber.isNotEmpty) {
                                authNotifier.sendOTP(fullPhoneNumber).then((_) {
                                  if (authNotifier.isOTPSent) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => OTPScreen(
                                              phoneNumber: fullPhoneNumber,
                                              isDriver: widget.isDriver,
                                            ),
                                      ),
                                    );
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a phone number',
                                    ),
                                  ),
                                );
                              }
                            },
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
