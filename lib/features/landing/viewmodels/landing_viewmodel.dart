import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingViewModel {
  void navigateToPhoneScreen() {}
  void navigateToDriverScreen() {}
}

final landingViewModelProvider = Provider<LandingViewModel>((ref) {
  return LandingViewModel();
});