import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message,
  SnackBarType type,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: AppSizes.font5XL,
        ),
      ),
      backgroundColor: type == SnackBarType.error
          ? Theme.of(context).colorScheme.error
          : type == SnackBarType.warning
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.tertiary,
    ),
  );
}

enum SnackBarType { error, warning, success }