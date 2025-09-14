
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalorieProgressWidget extends StatelessWidget {
  final int currentCalories;
  final int targetCalories;
  final AnimationController animationController;

  const CalorieProgressWidget({
    super.key,
    required this.currentCalories,
    required this.targetCalories,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentCalories / targetCalories;
    final remaining = targetCalories - currentCalories;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Ring
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background ring
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Progress ring
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: progress * animationController.value,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(progress),
                        ),
                      ),
                    );
                  },
                ),
                // Center content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentCalories',
                      style:
                          AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'de $targetCalories kcal',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      remaining > 0 ? '$remaining restantes' : 'Meta atingida!',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: remaining > 0
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.primary,
                        fontWeight:
                            remaining > 0 ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Progress percentage
          Text(
            '${(progress * 100).toInt()}% da meta diária',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // Tip text
          Text(
            'Toque longo para ver detalhes',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (progress >= 0.8) {
      return Colors.green;
    } else if (progress >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
