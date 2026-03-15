import 'package:flutter/material.dart';
import '../theme/colors.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final int gradientIndex;
  final VoidCallback? onPress;
  final double borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    this.gradientIndex = 0,
    this.onPress,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        AppColors.gradientPresets[gradientIndex % AppColors.gradientPresets.length];

    final content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (onPress != null) {
      return GestureDetector(
        onTap: onPress,
        child: content,
      );
    }

    return content;
  }
}
