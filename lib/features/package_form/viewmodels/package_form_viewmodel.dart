import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/package_repository.dart';
import '../../../models/package.dart';

class PackageFormViewModel {
  final PackageRepository _repository;

  PackageFormViewModel(this._repository);

  Future<void> submitPackage(Package package) async {
    await _repository.submitPackage(package);
  }
}

final packageFormViewModelProvider = Provider<PackageFormViewModel>((ref) {
  return PackageFormViewModel(PackageRepository());
});