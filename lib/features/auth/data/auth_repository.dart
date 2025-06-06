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