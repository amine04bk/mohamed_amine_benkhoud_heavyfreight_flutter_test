import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heavyfreight_app/features/driver/presentation/providers/driver_provider.dart';

class DriverViewModel {
  final WidgetRef ref;

  DriverViewModel(this.ref);

  DriverState get state => ref.watch(driverProvider);

  Future<void> fetchJobs() async {
    await ref.read(driverProvider.notifier).fetchJobs();
  }

  Future<void> acceptJob(String jobId) async {
    await ref.read(driverProvider.notifier).acceptJob(jobId);
  }
}