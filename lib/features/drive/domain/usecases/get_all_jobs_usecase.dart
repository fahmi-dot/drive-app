import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';

class GetAllJobsUseCase {
  final JobRepository _jobRepository;

  GetAllJobsUseCase(this._jobRepository);

  Future<List<Job>> execute() async {
    return await _jobRepository.getAllJobs();
  }
}