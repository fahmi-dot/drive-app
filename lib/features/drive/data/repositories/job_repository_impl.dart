import 'package:driver_app/features/drive/data/datasources/job_datasource.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobDataSource jobDataSource;

  JobRepositoryImpl({required this.jobDataSource});

  @override
  Future<List<Job>> getAllJobs() async {
    final jobsModel = await jobDataSource.getAllJobs();

    return jobsModel.map((j) => j.toEntity()).toList();
  }
}