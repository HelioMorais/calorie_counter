import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalorieGoalSelectorWidget extends StatefulWidget {
  final int currentGoal;
  final Function(int) onGoalSelected;

  const CalorieGoalSelectorWidget({
    super.key,
    required this.currentGoal,
    required this.onGoalSelected,
  });

  @override
  State<CalorieGoalSelectorWidget> createState() =>
      _CalorieGoalSelectorWidgetState();
}

class _CalorieGoalSelectorWidgetState extends State<CalorieGoalSelectorWidget> {
  late int _selectedGoal;
  bool _isCustom = false;
  final TextEditingController _customController = TextEditingController();
  final List<int> _presetGoals = [1200, 1500, 1800, 2000, 2200, 2500];

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.currentGoal;
    _isCustom = !_presetGoals.contains(widget.currentGoal);
    if (_isCustom) {
      _customController.text = widget.currentGoal.toString();
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _selectGoal(int goal) {
    setState(() {
      _selectedGoal = goal;
      _isCustom = false;
    });
  }

  void _selectCustom() {
    setState(() {
      _isCustom = true;
      if (_customController.text.isEmpty) {
        _customController.text = _selectedGoal.toString();
      }
    });
  }

  void _onCustomValueChanged(String value) {
    final customGoal = int.tryParse(value);
    if (customGoal != null && customGoal >= 800 && customGoal <= 5000) {
      setState(() {
        _selectedGoal = customGoal;
      });
    }
  }

  bool get _isValidSelection {
    if (_isCustom) {
      final customGoal = int.tryParse(_customController.text);
      return customGoal != null && customGoal >= 800 && customGoal <= 5000;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Daily Calorie Goal',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your daily calorie target',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Preset goals
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Preset options
                  ...(_presetGoals.map((goal) => _buildGoalOption(goal))),

                  const SizedBox(height: 16),

                  // Custom option
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isCustom
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: _isCustom ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _selectCustom,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isCustom,
                                onChanged: (_) => _selectCustom(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Custom Goal',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      onChanged: _onCustomValueChanged,
                                      onTap: _selectCustom,
                                      decoration: InputDecoration(
                                        hintText: 'Enter calories (800-5000)',
                                        suffixText: 'kcal',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                          ),
                                        ),
                                        errorText: _isCustom &&
                                                !_isValidSelection
                                            ? 'Enter a value between 800-5000 kcal'
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isValidSelection
                              ? () => widget.onGoalSelected(_selectedGoal)
                              : null,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption(int goal) {
    final isSelected = !_isCustom && _selectedGoal == goal;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectGoal(goal),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<int>(
                  value: goal,
                  groupValue: _isCustom ? null : _selectedGoal,
                  onChanged: (value) => _selectGoal(value!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$goal kcal',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getGoalDescription(goal),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGoalDescription(int goal) {
    switch (goal) {
      case 1200:
        return 'Weight loss (sedentary)';
      case 1500:
        return 'Weight loss (active)';
      case 1800:
        return 'Maintenance (sedentary)';
      case 2000:
        return 'Maintenance (moderate activity)';
      case 2200:
        return 'Maintenance (active)';
      case 2500:
        return 'Weight gain or high activity';
      default:
        return 'Custom goal';
    }
  }
}
