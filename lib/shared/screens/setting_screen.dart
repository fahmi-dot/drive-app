import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/features/auth/domain/entities/biometric.dart';
import 'package:driver_app/features/auth/presentation/providers/biometric_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  Widget _buildBiometricStatusCard({
    required HeroIcons icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: color.withValues(alpha: 0.3)
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(
              icon, 
              color: color, 
              size: AppSizes.paddingL * 2
            ),
          ),
          const SizedBox(width: AppSizes.paddingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: AppSizes.fontXL - 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: AppSizes.fontL,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biometric = ref.watch(biometricProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.settingsTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppSizes.font2XL - 2,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.paddingL),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.biometricInfo,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: AppSizes.font5XL,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
                biometric.when(
                  data: (settings) {
                    if (!settings.isAvailable) {
                      return _buildBiometricStatusCard(
                        icon: HeroIcons.shieldExclamation,
                        title: AppStrings.biometricNotAvailable,
                        subtitle: settings.status == BiometricStatus.notEnrolled
                            ? AppStrings.notEnrolledBiometric
                            : AppStrings.unsupportedBiometric,
                        color: Theme.of(context).colorScheme.errorContainer,
                      );
                    }
            
                    return _buildBiometricStatusCard(
                      icon: HeroIcons.fingerPrint,
                      title: AppStrings.biometricAvailable,
                      subtitle: '${AppStrings.type}: ${settings.availableTypeString}',
                      color: Theme.of(context).colorScheme.tertiary,
                    );
                  },
                  loading: () => Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.paddingL),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  error: (error, stack) => _buildBiometricStatusCard(
                    icon: HeroIcons.exclamationCircle,
                    title: AppStrings.error,
                    subtitle: error.toString(),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            const Divider(height: AppSizes.padding2XL * 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.biometricSettings,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: AppSizes.font5XL,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                biometric.maybeWhen(
                  data: (settings) {
                    if (!settings.isAvailable) {
                      return Padding(
                        padding: EdgeInsets.all(AppSizes.paddingL),
                        child: Text(
                          AppStrings.biometricNotAvailable,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
            
                    return Column(
                      children: [
                        SwitchListTile(
                          title: Text(
                            AppStrings.openAppBiometricTitle,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppSizes.font5XL,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            AppStrings.openAppBiometricSubtitle,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: AppSizes.fontL,
                            ),
                          ),
                          secondary: HeroIcon(settings.isEnable
                              ? HeroIcons.lockClosed
                              : HeroIcons.lockOpen, 
                          color: Theme.of(context).colorScheme.secondary,
                          ),
                          value: settings.isEnable,
                          onChanged: (value) {
                            ref.read(biometricProvider.notifier).toggleIsEnable(value);
                          },
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}