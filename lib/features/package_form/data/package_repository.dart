import '../../../models/package.dart';

class PackageRepository {
  Future<void> submitPackage(Package package) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  }
}