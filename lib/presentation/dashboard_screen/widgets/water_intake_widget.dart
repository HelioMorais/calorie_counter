import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WaterIntakeWidget extends StatelessWidget {
  final int waterIntake;
  final Function(int) onDropletTapped;
  final AnimationController animationController;

  const WaterIntakeWidget({
    super.key,
    required this.waterIntake,
    required this.onDropletTapped,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'water_drop',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Ingestão de Água',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$waterIntake/8',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Copos de água hoje',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) {
              final isFilled = index < waterIntake;
              return GestureDetector(
                onTap: () => onDropletTapped(index),
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Container(
                      width: 32,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isFilled
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'water_drop',
                          color: isFilled
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.5),
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: waterIntake / 8,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Meta: 8 copos por dia',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
