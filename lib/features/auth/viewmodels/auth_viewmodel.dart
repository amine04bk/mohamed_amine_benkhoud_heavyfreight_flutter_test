import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _repository;

  AuthViewModel(this._repository);

  Future<bool> sendOTP(String phoneNumber) async {
    return await _repository.sendOTP(phoneNumber);
  }

  Future<bool> verifyOTP(String otp) async {
    return await _repository.verifyOTP(otp);
  }
}

final authViewModelProvider = Provider<AuthViewModel>((ref) {
  return AuthViewModel(AuthRepository());
});