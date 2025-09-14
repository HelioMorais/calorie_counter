import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/calorie_progress_widget.dart';
import './widgets/macronutrient_progress_widget.dart';
import './widgets/offline_banner_widget.dart';
import './widgets/water_intake_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _currentCalories = 0;
  final int _targetCalories = 2000;
  int _waterIntake = 0;

  // Macronutrient data
  final Map<String, dynamic> _macronutrients = {
    'carbs': {'current': 0, 'target': 250, 'unit': 'g'},
    'protein': {'current': 0, 'target': 150, 'unit': 'g'},
    'fat': {'current': 0, 'target': 67, 'unit': 'g'},
  };

  late AnimationController _progressAnimationController;
  late AnimationController _waterAnimationController;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _waterAnimationController.dispose();
    super.dispose();
  }

  void _onWaterDropletTapped(int index) {
    if (index < _waterIntake) {
      setState(() {
        _waterIntake = index;
      });
    } else {
      setState(() {
        _waterIntake = index + 1;
      });
    }

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Animate water droplet
    _waterAnimationController.forward().then((_) {
      _waterAnimationController.reverse();
    });
  }

  void _onRefresh() async {
    setState(() {
      _currentCalories = 0;
      _waterIntake = 0;
      _macronutrients['carbs']['current'] = 0;
      _macronutrients['protein']['current'] = 0;
      _macronutrients['fat']['current'] = 0;
    });

    _progressAnimationController.reset();
    _progressAnimationController.forward();

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _showProgressDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalhes do Progresso Diário',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Calorias', '\$_currentCalories / \$_targetCalories kcal'),
            _buildDetailRow('Carboidratos',
                '${_macronutrients['carbs']['current']} / ${_macronutrients['carbs']['target']} g'),
            _buildDetailRow('Proteína',
                '${_macronutrients['protein']['current']} / ${_macronutrients['protein']['target']} g'),
            _buildDetailRow('Gordura',
                '${_macronutrients['fat']['current']} / ${_macronutrients['fat']['target']} g'),
            _buildDetailRow('Água', '\$_waterIntake / 8 copos'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _onRefresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Offline Banner
                const OfflineBannerWidget(),

                const SizedBox(height: 24),

                // Welcome Text
                Text(
                  'Progresso de Hoje',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Acompanhe suas metas nutricionais',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // Calorie Progress Ring
                GestureDetector(
                  onLongPress: _showProgressDetails,
                  child: CalorieProgressWidget(
                    currentCalories: _currentCalories,
                    targetCalories: _targetCalories,
                    animationController: _progressAnimationController,
                  ),
                ),

                const SizedBox(height: 32),

                // Macronutrient Progress Bars
                MacronutrientProgressWidget(
                  macronutrients: _macronutrients,
                  animationController: _progressAnimationController,
                ),

                const SizedBox(height: 32),

                // Water Intake Section
                WaterIntakeWidget(
                  waterIntake: _waterIntake,
                  onDropletTapped: _onWaterDropletTapped,
                  animationController: _waterAnimationController,
                ),

                const SizedBox(height: 32),

                // Empty State Message
                if (_currentCalories == 0) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'restaurant',
                          size: 48,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Comece Bem o Seu Dia!',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Registre sua primeira refeição para começar a acompanhar suas metas nutricionais.',
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              Navigator.pushNamed(context, '/history-screen');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings-screen');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              size: 24,
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            label: 'Painel',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              size: 24,
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              size: 24,
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            label: 'Configurações',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/food-logging-screen');
        },
        child: CustomIconWidget(
          iconName: 'add',
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
