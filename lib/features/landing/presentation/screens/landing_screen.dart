import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/core/constants/app_colors.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/core/widgets/custom_button.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/features/auth/presentation/screens/phone_screen.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset('assets/mainbg.jpg', fit: BoxFit.cover),
          ),

          // Foreground content
          Column(
            children: [
              const SizedBox(height: 50), // Reduced from 100 to 50
              const Center(
                child: Text(
                  'HeavyFreight',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Center(
                child: Text(
                  'TRANSPORTATIONS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 221, 221, 221),
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.5,
              ), // Dynamic spacing based on screen height
              // Expanded white container filling remaining space
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            text: 'Connect as Client',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PhoneScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Connect as Driver',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const PhoneScreen(isDriver: true),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
