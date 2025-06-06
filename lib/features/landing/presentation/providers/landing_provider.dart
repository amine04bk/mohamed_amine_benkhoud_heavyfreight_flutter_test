import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/landing_viewmodel.dart';

final landingProvider = StateNotifierProvider<LandingNotifier, bool>((ref) {
  return LandingNotifier(ref.read(landingViewModelProvider));
});

class LandingNotifier extends StateNotifier<bool> {
  final LandingViewModel _viewModel;

  LandingNotifier(this._viewModel) : super(false);

  void navigateToPhone() {
    _viewModel.navigateToPhoneScreen();
  }

  void navigateToDriver() {
    _viewModel.navigateToDriverScreen();
  }
}