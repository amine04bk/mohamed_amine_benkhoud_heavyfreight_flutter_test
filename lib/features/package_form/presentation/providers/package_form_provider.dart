import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/package_form_viewmodel.dart';
import '../../../../models/package.dart';

final packageFormProvider =
    StateNotifierProvider<PackageFormNotifier, Package?>((ref) {
  return PackageFormNotifier(ref.read(packageFormViewModelProvider));
});

final selectedPackageSizeProvider = StateProvider<String?>((ref) {
  return null; // Default to no selection
});

final selectedDeliveryTypeProvider = StateProvider<String?>((ref) {
  return null; // Default to no selection
});

class PackageFormNotifier extends StateNotifier<Package?> {
  final PackageFormViewModel _viewModel;

  PackageFormNotifier(this._viewModel) : super(null);

  void setPackage(Package package) {
    state = package;
  }

  Future<void> submitPackage() async {
    if (state != null) {
      await _viewModel.submitPackage(state!);
    }
  }
}