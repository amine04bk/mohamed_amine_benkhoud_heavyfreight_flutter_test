import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heavyfreight_app/features/driver/data/driver_repository.dart';

class DriverState {
  final List<Job> jobs;
  final bool isLoading;
  final String? errorMessage;

  DriverState({required this.jobs, this.isLoading = false, this.errorMessage});

  DriverState copyWith({
    List<Job>? jobs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DriverState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DriverNotifier extends StateNotifier<DriverState> {
  final DriverRepository _repository;

  DriverNotifier(this._repository)
    : super(DriverState(jobs: [], isLoading: true)) {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      state = state.copyWith(isLoading: true);
      final jobs = await _repository.fetchJobs();
      state = state.copyWith(jobs: jobs, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load jobs: $e',
      );
    }
  }

  Future<void> acceptJob(String jobId) async {
    try {
      await _repository.acceptJob(jobId);
      final updatedJobs =
          state.jobs.map((job) {
            if (job.id == jobId) {
              return Job(
                id: job.id,
                pickupLocation: job.pickupLocation,
                dropoffLocation: job.dropoffLocation,
                size: job.size,
                pay: job.pay,
                isAccepted: true,
              );
            }
            return job;
          }).toList();
      state = state.copyWith(jobs: updatedJobs);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to accept job: $e');
    }
  }
}

final driverProvider = StateNotifierProvider<DriverNotifier, DriverState>((
  ref,
) {
  return DriverNotifier(DriverRepository());
});
