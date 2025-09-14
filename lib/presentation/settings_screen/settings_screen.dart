import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import './widgets/calorie_goal_selector_widget.dart';
import './widgets/settings_row_widget.dart';
import './widgets/settings_section_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentCalorieGoal = 2000;
  bool _isMetricUnits = true;
  bool _dailyReminders = true;
  bool _mealReminders = false;
  bool _waterReminders = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 3);
    _loadSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentCalorieGoal = prefs.getInt('calorie_goal') ?? 2000;
      _isMetricUnits = prefs.getBool('metric_units') ?? true;
      _dailyReminders = prefs.getBool('daily_reminders') ?? true;
      _mealReminders = prefs.getBool('meal_reminders') ?? false;
      _waterReminders = prefs.getBool('water_reminders') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calorie_goal', _currentCalorieGoal);
    await prefs.setBool('metric_units', _isMetricUnits);
    await prefs.setBool('daily_reminders', _dailyReminders);
    await prefs.setBool('meal_reminders', _mealReminders);
    await prefs.setBool('water_reminders', _waterReminders);
  }

  void _showCalorieGoalSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalorieGoalSelectorWidget(
        currentGoal: _currentCalorieGoal,
        onGoalSelected: (goal) {
          setState(() {
            _currentCalorieGoal = goal;
          });
          _saveSettings();
          Navigator.pop(context);
          _showSuccessSnackBar(
              'Meta de calorias atualizada para $_currentCalorieGoal kcal');
        },
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Redefinir Progresso',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Isto irá apagar permanentemente todos os seus dados de comidas registradas, ingestão de água e dados de progresso. Esta ação não pode ser desfeita.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetProgress();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Redefinir'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_calories');
    await prefs.remove('water_intake');
    await prefs.remove('food_history');
    _showSuccessSnackBar('Dados de progresso foram redefinidos');
  }

  void _exportData() {
    _showSuccessSnackBar('Funcionalidade de exportar dados em breve');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _openPrivacyPolicy() {
    _showSuccessSnackBar('Política de privacidade abriria no navegador');
  }

  void _openTermsOfService() {
    _showSuccessSnackBar('Termos de serviço abririam no navegador');
  }

  void _contactSupport() {
    _showSuccessSnackBar('Funcionalidade de contato com suporte em breve');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // Daily Calorie Goal Section
                  SettingsSectionWidget(
                    title: 'Meta Diária de Calorias',
                    children: [
                      SettingsRowWidget(
                        title: 'Calorias Meta',
                        subtitle: 'Defina sua meta diária de calorias',
                        value: '$_currentCalorieGoal kcal',
                        onTap: _showCalorieGoalSelector,
                        showDisclosure: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Units Section
                  SettingsSectionWidget(
                    title: 'Unidades',
                    children: [
                      SettingsRowWidget(
                        title: 'Sistema de Medidas',
                        subtitle: 'Escolha suas unidades preferidas',
                        value: _isMetricUnits ? 'Métrico' : 'Imperial',
                        trailing: Switch(
                          value: _isMetricUnits,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _isMetricUnits = value;
                            });
                            _saveSettings();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notifications Section
                  SettingsSectionWidget(
                    title: 'Notificações',
                    children: [
                      SettingsRowWidget(
                        title: 'Lembretes Diários',
                        subtitle:
                            'Receba lembretes para registrar suas refeições',
                        trailing: Switch(
                          value: _dailyReminders,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _dailyReminders = value;
                            });
                            _saveSettings();
                          },
                        ),
                      ),
                      SettingsRowWidget(
                        title: 'Lembretes de Refeição',
                        subtitle: 'Alertas de café da manhã, almoço e jantar',
                        trailing: Switch(
                          value: _mealReminders,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _mealReminders = value;
                            });
                            _saveSettings();
                          },
                        ),
                      ),
                      SettingsRowWidget(
                        title: 'Lembretes de Água',
                        subtitle: 'Mantenha-se hidratado durante o dia',
                        trailing: Switch(
                          value: _waterReminders,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _waterReminders = value;
                            });
                            _saveSettings();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Data Management Section
                  SettingsSectionWidget(
                    title: 'Gerenciamento de Dados',
                    children: [
                      SettingsRowWidget(
                        title: 'Redefinir Progresso',
                        subtitle: 'Limpar todos os dados registrados',
                        onTap: _showResetConfirmation,
                        showDisclosure: true,
                        isDestructive: true,
                      ),
                      SettingsRowWidget(
                        title: 'Exportar Dados',
                        subtitle: 'Baixar seus dados nutricionais',
                        onTap: _exportData,
                        showDisclosure: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // About Section
                  SettingsSectionWidget(
                    title: 'Sobre',
                    children: [
                      SettingsRowWidget(
                        title: 'Versão do App',
                        subtitle: 'ContadorCalorias v1.0.0',
                        value: 'Modo Demo',
                      ),
                      SettingsRowWidget(
                        title: 'Demo Offline',
                        subtitle:
                            'Base de dados nutricional offline—somente modo demo',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'DEMO',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SettingsRowWidget(
                        title: 'Suporte',
                        subtitle: 'Obtenha ajuda e entre em contato',
                        onTap: _contactSupport,
                        showDisclosure: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Footer Links
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _openPrivacyPolicy,
                              child: Text(
                                'Política de Privacidade',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            Text(
                              ' • ',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            TextButton(
                              onPressed: _openTermsOfService,
                              child: Text(
                                'Termos de Serviço',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            Container(
              decoration: BoxDecoration(
                color: AppTheme
                    .lightTheme.bottomNavigationBarTheme.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.pushReplacementNamed(
                          context, '/dashboard-screen');
                      break;
                    case 1:
                      Navigator.pushReplacementNamed(
                          context, '/food-logging-screen');
                      break;
                    case 2:
                      Navigator.pushReplacementNamed(
                          context, '/history-screen');
                      break;
                    case 3:
                      // Already on settings screen
                      break;
                  }
                },
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: _tabController.index == 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Painel',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'restaurant',
                      color: _tabController.index == 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Comida',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'history',
                      color: _tabController.index == 2
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Histórico',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: _tabController.index == 3
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Configurações',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
