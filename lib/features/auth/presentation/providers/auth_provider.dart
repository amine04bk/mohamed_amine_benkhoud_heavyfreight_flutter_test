import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/auth_viewmodel.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authViewModelProvider));
});

class AuthState {
  final String? phoneNumber;
  final bool isVerified;
  final bool isOTPSent;
  final int timerSeconds;

  AuthState({
    this.phoneNumber,
    this.isVerified = false,
    this.isOTPSent = false,
    this.timerSeconds = 60,
  });

  AuthState copyWith({
    String? phoneNumber,
    bool? isVerified,
    bool? isOTPSent,
    int? timerSeconds,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      isOTPSent: isOTPSent ?? this.isOTPSent,
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthViewModel _viewModel;
  late Timer _timer;

  AuthNotifier(this._viewModel) : super(AuthState());

  Future<void> sendOTP(String phoneNumber) async {
    final success = await _viewModel.sendOTP(phoneNumber);
    if (success) {
      state = state.copyWith(
        phoneNumber: phoneNumber,
        isOTPSent: true,
        timerSeconds: 90, // Reset to 01:30 for consistency with OTPScreen
      );
      startTimer();
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (state.phoneNumber != null) {
      final success = await _viewModel.verifyOTP(otp);
      state = state.copyWith(isVerified: success);
      if (success) {
        state = state.copyWith(isOTPSent: false);
      }
    }
  }

  void startTimer() {
    state = state.copyWith(timerSeconds: 90);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 0) {
        state = state.copyWith(timerSeconds: state.timerSeconds - 1);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int get timerSeconds => state.timerSeconds;
  bool get isOTPSent => state.isOTPSent;
  bool get isVerified => state.isVerified;
}

class AuthRepository {
  Future<bool> sendOTP(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return true; // Mock OTP sending
  }

  Future<bool> verifyOTP(String otp) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return otp == "1234"; // Mock OTP verification
  }
}