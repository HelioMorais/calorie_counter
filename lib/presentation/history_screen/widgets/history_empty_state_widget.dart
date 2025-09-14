import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class HistoryEmptyStateWidget extends StatelessWidget {
  const HistoryEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageWidget(
            imageUrl: 'assets/images/sad_face.svg',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhum histórico encontrado',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Comece a registrar suas refeições para ver seu progresso aqui.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/food-logging-screen');
            },
            icon: CustomIconWidget(
              iconName: 'restaurant',
              color: Colors.white,
              size: 20,
            ),
            label: const Text('Adicionar Primeira Refeição'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}