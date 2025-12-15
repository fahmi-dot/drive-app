import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/core/router/app_router.dart';
import 'package:driver_app/features/auth/presentation/providers/biometric_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      final settings = await ref.read(biometricProvider.notifier).getBiometricSettings();
      
      if (mounted) {
        if (settings.isEnable) {
          return context.go(Routes.gate);
        }
        context.go(Routes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppStrings.appName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 32.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'cursive',
          ),
        ),
      ),
    );
  }
}