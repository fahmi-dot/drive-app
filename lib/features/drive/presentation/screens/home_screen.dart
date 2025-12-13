import 'package:driver_app/features/drive/presentation/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'UDrive',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: jobState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error loading jobs: $e',
          ),
        ), 
        data: (jobs) {
          if (jobs.isEmpty) return Center(child: Text('No jobs yet.'));

          return ListView.separated(
            itemCount: jobs.length,
            separatorBuilder: (context, index) => Divider(height: 1), 
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                title: Text(job.customerName),
              );
            }, 
          );
        }, 
      ),
    );
  }
}