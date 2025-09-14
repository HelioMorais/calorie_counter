import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HistoryDayCardWidget extends StatefulWidget {
  final Map<String, dynamic> dayData;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const HistoryDayCardWidget({
    super.key,
    required this.dayData,
    required this.onTap,
    required this.onDelete,
    required this.onShare,
  });

  @override
  State<HistoryDayCardWidget> createState() => _HistoryDayCardWidgetState();
}

class _HistoryDayCardWidgetState extends State<HistoryDayCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getAdherenceColor(String status) {
    switch (status) {
      case 'good':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'close':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'over':
      case 'under':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getAdherenceText(String status) {
    switch (status) {
      case 'good':
        return 'Goal Met';
      case 'close':
        return 'Close to Goal';
      case 'over':
        return 'Over Goal';
      case 'under':
        return 'Under Goal';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dayToCheck = DateTime(date.year, date.month, date.day);

    if (dayToCheck == today) {
      return 'Today';
    } else if (dayToCheck == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.dayData["date"] as DateTime;
    final totalCalories = widget.dayData["totalCalories"] as int;
    final targetCalories = widget.dayData["targetCalories"] as int;
    final adherenceStatus = widget.dayData["adherenceStatus"] as String;
    final macros = widget.dayData["macronutrients"] as Map<String, dynamic>;
    final waterIntake = widget.dayData["waterIntake"] as int;
    final waterTarget = widget.dayData["waterTarget"] as int;
    final foodItems = widget.dayData["foodItems"] as List<dynamic>;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key(widget.dayData["id"].toString()),
        background: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'visibility',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                'View Details',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            widget.onDelete();
            return false;
          } else {
            _toggleExpansion();
            return false;
          }
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: _toggleExpansion,
            onLongPress: () {
              _showShareOptions();
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main card content
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(date),
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Text(
                                  '$totalCalories',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  ' / $targetCalories kcal',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getAdherenceColor(adherenceStatus)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getAdherenceText(adherenceStatus),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getAdherenceColor(adherenceStatus),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          CustomIconWidget(
                            iconName:
                                _isExpanded ? 'expand_less' : 'expand_more',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Progress bar
                  SizedBox(height: 2.h),
                  LinearProgressIndicator(
                    value: totalCalories / targetCalories,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getAdherenceColor(adherenceStatus),
                    ),
                    minHeight: 6,
                  ),

                  // Expanded content
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.h),

                        // Macronutrients
                        Text(
                          'Macronutrients',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        _buildMacroRow(
                          'Carbohydrates',
                          macros["carbs"]["consumed"],
                          macros["carbs"]["target"],
                          AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                        SizedBox(height: 1.h),
                        _buildMacroRow(
                          'Protein',
                          macros["protein"]["consumed"],
                          macros["protein"]["target"],
                          AppTheme.lightTheme.colorScheme.secondary,
                        ),
                        SizedBox(height: 1.h),
                        _buildMacroRow(
                          'Fat',
                          macros["fat"]["consumed"],
                          macros["fat"]["target"],
                          AppTheme.lightTheme.colorScheme.primary,
                        ),

                        SizedBox(height: 3.h),

                        // Water intake
                        Row(
                          children: [
                            Text(
                              'Water Intake',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$waterIntake / $waterTarget glasses',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: List.generate(8, (index) {
                            return Container(
                              margin: EdgeInsets.only(right: 1.w),
                              child: CustomIconWidget(
                                iconName: 'water_drop',
                                color: index < waterIntake
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline,
                                size: 20,
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: 3.h),

                        // Food items
                        Text(
                          'Food Items',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        ...foodItems.map((item) => _buildFoodItem(item)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroRow(String name, int consumed, int target, Color color) {
    final progress = consumed / target;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: progress > 1.0 ? 1.0 : progress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          '${consumed}g / ${target}g',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${item["meal"]} • ${item["time"]}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item["calories"]} kcal',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Share Progress',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share Summary'),
              onTap: () {
                Navigator.pop(context);
                widget.onShare();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'screenshot',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share Screenshot'),
              onTap: () {
                Navigator.pop(context);
                widget.onShare();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
