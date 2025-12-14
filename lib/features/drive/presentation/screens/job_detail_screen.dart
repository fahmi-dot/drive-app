import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/domain/entities/stop.dart';
import 'package:driver_app/features/drive/presentation/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const JobDetailScreen({super.key, required this.id});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

  Widget _buildStopCard(
    Job job,
    Stop stop,
    int number,
  ) {
    return Column(
      children: [
        Card(
          elevation: stop.isCompleted ? 1 : 2,
          color: stop.isCompleted 
              ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5) 
              : Theme.of(context).colorScheme.surface,
          child: InkWell(
            onTap: job.isOngoing && !stop.isCompleted
                ? () => context.pop()
                : null,
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: stop.isCompleted 
                          ? Theme.of(context).colorScheme.tertiary 
                          : stop.typeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: stop.isCompleted
                          ? HeroIcon(
                              HeroIcons.check,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: AppSizes.iconXL,
                            )
                          : Text(
                              '$number',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingXS,
                            horizontal: AppSizes.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: stop.typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                          ),
                          child: Text(
                            stop.typeLabel,
                            style: TextStyle(
                              color: stop.typeColor,
                              fontSize: AppSizes.fontM,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingS),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeroIcon(
                              HeroIcons.mapPin,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              size: AppSizes.iconL,
                              style: HeroIconStyle.solid,
                            ),
                            const SizedBox(width: AppSizes.paddingXS),
                            Expanded(
                              child: Text(
                                stop.address,
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  color: stop.isCompleted
                                      ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (stop.isCompleted && stop.completedAt != null) ...[
                          const SizedBox(height: AppSizes.paddingS),
                          Row(
                            children: [
                              HeroIcon(
                                HeroIcons.checkBadge,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: AppSizes.iconL,
                              ),
                              const SizedBox(width: AppSizes.paddingXS),
                              Text(
                                '${AppStrings.completedAt} ${DateFormat('HH:mm').format(stop.completedAt!)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: AppSizes.fontM,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (job.isOngoing && !stop.isCompleted)
                    HeroIcon(
                      HeroIcons.chevronRight,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: AppSizes.iconL,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartJobButton(String id) {
    return ElevatedButton(
      onPressed: () => _showStartJobDialog(id),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingL),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusS)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.play,
            color: Theme.of(context).colorScheme.onPrimary,
            size: AppSizes.iconL,
            style: HeroIconStyle.solid,
          ),
          const SizedBox(width: AppSizes.paddingS),
          Text(
            AppStrings.startJob,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: AppSizes.fontL, 
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _showStartJobDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppStrings.startJob,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppSizes.fontXL,
          ),
        ),
        content: Text(
          AppStrings.startJobAsk,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: AppSizes.fontM,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: AppSizes.fontM,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(jobProvider.notifier).startJob(id);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppStrings.jobStartedNotif,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: AppSizes.fontM,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: Text(
              AppStrings.start,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: AppSizes.fontM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);

    if (jobState.value == null) return CircularProgressIndicator();

    final job = jobState.value!.firstWhere((j) => j.id == widget.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.details,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppSizes.font2XL,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppSizes.font2XL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Row(
                    children: [
                      HeroIcon(
                        HeroIcons.buildingOffice,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: AppSizes.iconXL,
                      ),
                      const SizedBox(width: AppSizes.paddingS),
                      Text(
                        job.customerName, 
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: AppSizes.fontXL,
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Row(
                    children: [
                      HeroIcon(
                        HeroIcons.clock,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        size: AppSizes.iconXL,
                      ),
                      const SizedBox(width: AppSizes.paddingS),
                      Text(
                        '${AppStrings.createdAt} ${dateFormat.format(job.createdAt)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: AppSizes.fontL, 
                        ),
                      ),
                    ],
                  ),
                  if (job.isOngoing || job.isCompleted) ...[
                    const SizedBox(height: AppSizes.paddingS),
                    Row(
                      children: [
                        HeroIcon(job.isOngoing
                              ? HeroIcons.truck
                              : HeroIcons.checkBadge,
                          color: job.isOngoing 
                              ? Theme.of(context).colorScheme.secondary 
                              : Theme.of(context).colorScheme.tertiary,
                          size: AppSizes.iconXL,
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Text(job.isOngoing
                              ? '${AppStrings.startedAt} ${dateFormat.format(job.startedAt!)}'
                              : '${AppStrings.completedAt} ${dateFormat.format(job.completedAt!)}',
                          style: TextStyle(
                            color: job.isOngoing 
                                ? Theme.of(context).colorScheme.secondary 
                                : Theme.of(context).colorScheme.tertiary,
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
            
                  if (job.isOngoing) ...[
                    const SizedBox(height: AppSizes.paddingL),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: job.progress,
                            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary
                            ),
                            minHeight: 8.0,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingM),
                        Text(
                          '${(job.progress * 100).toInt()}%',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: AppSizes.fontXL,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.padding2XL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.stopList} (${job.completedStopsCount}/${job.totalStops})',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppSizes.fontXL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: job.stops.length,
                    itemBuilder: (context, index) {
                      final stop = job.stops[index];

                      return _buildStopCard(
                        job,
                        stop,
                        index + 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: job.canStart
          ? Container(
            padding: EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: _buildStartJobButton(job.id),
          ) : null,
    );
  }
}
