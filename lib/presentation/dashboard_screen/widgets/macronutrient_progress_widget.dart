import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MacronutrientProgressWidget extends StatelessWidget {
  final Map<String, dynamic> macronutrients;
  final AnimationController animationController;

  const MacronutrientProgressWidget({
    super.key,
    required this.macronutrients,
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
          Text(
            'Macronutrientes',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildMacroBar(
            'Carboidratos',
            macronutrients['carbs']['current'],
            macronutrients['carbs']['target'],
            macronutrients['carbs']['unit'],
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildMacroBar(
            'Proteína',
            macronutrients['protein']['current'],
            macronutrients['protein']['target'],
            macronutrients['protein']['unit'],
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildMacroBar(
            'Gordura',
            macronutrients['fat']['current'],
            macronutrients['fat']['target'],
            macronutrients['fat']['unit'],
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(
      String name, int current, int target, String unit, Color color) {
    final progress = current / target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$current/$target$unit',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: progress * animationController.value,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            );
          },
        ),
      ],
    );
  }
}
