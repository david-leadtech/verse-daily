import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';

class ErrorFallback extends StatelessWidget {
  final String message;
  final String? retryText;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorFallback({
    super.key,
    required this.message,
    this.retryText,
    this.onRetry,
    this.icon = FeatherIcons.wifiOff,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: AppColors.tabIconDefault),
              const SizedBox(height: 10),
              Text(
                message,
                style: AppTheme.interRegular(14).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (retryText != null) ...[
                const SizedBox(height: 6),
                Text(
                  retryText!,
                  style: AppTheme.interMedium(13).copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
