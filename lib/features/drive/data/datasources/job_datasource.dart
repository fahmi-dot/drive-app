import 'dart:convert';
import 'dart:developer';

import 'package:driver_app/features/drive/data/models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class JobDataSource {
  Future<List<JobModel>> getAllJobs();
}

class JobDataSourceImpl implements JobDataSource {
  static const _key = 'jobs';
  final SharedPreferences prefs;

  JobDataSourceImpl({required this.prefs});

  @override
  Future<List<JobModel>> getAllJobs() async {
    try {
      final jobsEncode = prefs.getString(_key);

      if (jobsEncode == null) return [];

      final List<dynamic> jobs = jsonDecode(jobsEncode);
      
      return jobs.map((j) => JobModel.fromJson(j)).toList();
    } catch (e) {
      log('Error getting all jobs: $e');
      return [];
    }
  }
}