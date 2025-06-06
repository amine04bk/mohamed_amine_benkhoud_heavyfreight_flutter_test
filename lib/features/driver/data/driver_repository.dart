class Job {
  final String id;
  final String pickupLocation;
  final String dropoffLocation;
  final String size;
  final double pay;
  bool isAccepted;

  Job({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.size,
    required this.pay,
    this.isAccepted = false,
  });
}

class DriverRepository {
  Future<List<Job>> fetchJobs() async {
    // Mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return [
      Job(
        id: '1',
        pickupLocation: 'Gabes 6011, Cité zou 1',
        dropoffLocation: 'Tunis 4021, Cité olympic',
        size: 'medium',
        pay: 50.0,
      ),
      Job(
        id: '2',
        pickupLocation: 'Sfax 3000',
        dropoffLocation: 'Monastir 5000',
        size: 'large',
        pay: 75.0,
      ),
    ];
  }

  Future<void> acceptJob(String jobId) async {
    // Simulate accepting a job
    await Future.delayed(const Duration(milliseconds: 300));
  }
}