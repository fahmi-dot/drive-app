import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/features/auth/presentation/providers/biometric_provider.dart';
import 'package:driver_app/features/drive/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class GateScreen extends ConsumerStatefulWidget {
  const GateScreen({super.key});

  @override
  ConsumerState<GateScreen> createState() => _BiometricGateScreenState();
}

class _BiometricGateScreenState extends ConsumerState<GateScreen> {
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();

    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authenticated = await ref
          .read(biometricProvider.notifier)
          .authenticate(
            reason: AppStrings.verifyIdentity,
          );

      if (authenticated) {
        setState(() {
          _isAuthenticated = true;
        });
      } else {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return HomeScreen();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              Theme.of(context).colorScheme.primary.withValues(alpha: 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.appName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'cursive',
                            ),
                          ),
                        )
                      ),
                      const SizedBox(height: AppSizes.paddingL * 2),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppSizes.font2XL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      Text(
                        AppStrings.verifyIdentity,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppSizes.font5XL,
                        ),
                      ),
                    ],
                  )
                ),
                Container(
                  width: AppSizes.iconMain,
                  height: AppSizes.iconMain,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: HeroIcon(
                    HeroIcons.fingerPrint,
                    size: AppSizes.iconMain / 2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 40.0),
                if (_isAuthenticating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: AppSizes.paddingL,
                        height: AppSizes.paddingL,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingXL),
                      Text(
                        AppStrings.verifying,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _authenticate,
                        icon: HeroIcon(
                          HeroIcons.fingerPrint,
                          size: AppSizes.iconXL,
                        ),
                        label: Text(
                          AppStrings.verifyNow,
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onPrimary,
                          foregroundColor: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingL,
                            horizontal: AppSizes.paddingL * 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radius2XL),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}