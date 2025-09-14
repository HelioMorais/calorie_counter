import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HistoryFilterBottomSheet extends StatefulWidget {
  final String selectedFilter;
  final DateTimeRange? selectedDateRange;
  final Function(String) onFilterChanged;
  final Function(DateTimeRange?) onDateRangeChanged;

  const HistoryFilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.selectedDateRange,
    required this.onFilterChanged,
    required this.onDateRangeChanged,
  });

  @override
  State<HistoryFilterBottomSheet> createState() =>
      _HistoryFilterBottomSheetState();
}

class _HistoryFilterBottomSheetState extends State<HistoryFilterBottomSheet> {
  late String _selectedFilter;
  DateTimeRange? _selectedDateRange;

  final List<Map<String, dynamic>> _filterOptions = [
    {
      'value': 'all',
      'label': 'All Days',
      'icon': 'calendar_today',
      'color': Colors.grey,
    },
    {
      'value': 'good',
      'label': 'Goal Met',
      'icon': 'check_circle',
      'color': AppTheme.lightTheme.colorScheme.secondary,
    },
    {
      'value': 'close',
      'label': 'Close to Goal',
      'icon': 'radio_button_unchecked',
      'color': AppTheme.lightTheme.colorScheme.tertiary,
    },
    {
      'value': 'over',
      'label': 'Over Goal',
      'icon': 'trending_up',
      'color': AppTheme.lightTheme.colorScheme.error,
    },
    {
      'value': 'under',
      'label': 'Under Goal',
      'icon': 'trending_down',
      'color': AppTheme.lightTheme.colorScheme.error,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
    _selectedDateRange = widget.selectedDateRange;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                  onPrimary: Colors.white,
                  surface: AppTheme.lightTheme.colorScheme.surface,
                  onSurface: AppTheme.lightTheme.colorScheme.onSurface,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearDateRange() {
    setState(() {
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onFilterChanged(_selectedFilter);
    widget.onDateRangeChanged(_selectedDateRange);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedFilter = 'all';
      _selectedDateRange = null;
    });
  }

  String _formatDateRange(DateTimeRange dateRange) {
    final start = dateRange.start;
    final end = dateRange.end;

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

    if (start.year == end.year && start.month == end.month) {
      return '${months[start.month - 1]} ${start.day} - ${end.day}, ${start.year}';
    } else if (start.year == end.year) {
      return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${start.year}';
    } else {
      return '${months[start.month - 1]} ${start.day}, ${start.year} - ${months[end.month - 1]} ${end.day}, ${end.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Title
                  Row(
                    children: [
                      Text(
                        'Filter History',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _resetFilters,
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Adherence Filter
                  Text(
                    'Adherence Status',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  ..._filterOptions.map((option) {
                    final isSelected = _selectedFilter == option['value'];
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFilter = option['value'];
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: option['icon'],
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : option['color'],
                                size: 24,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  option['label'],
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 4.h),

                  // Date Range Filter
                  Text(
                    'Date Range',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  InkWell(
                    onTap: _selectDateRange,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'date_range',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _selectedDateRange != null
                                  ? _formatDateRange(_selectedDateRange!)
                                  : 'Select date range',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: _selectedDateRange != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ),
                          if (_selectedDateRange != null)
                            IconButton(
                              onPressed: _clearDateRange,
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Quick Date Filters
                  Text(
                    'Quick Filters',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final now = DateTime.now();
                            setState(() {
                              _selectedDateRange = DateTimeRange(
                                start: now.subtract(const Duration(days: 7)),
                                end: now,
                              );
                            });
                          },
                          child: const Text('Last 7 days'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final now = DateTime.now();
                            setState(() {
                              _selectedDateRange = DateTimeRange(
                                start: now.subtract(const Duration(days: 30)),
                                end: now,
                              );
                            });
                          },
                          child: const Text('Last 30 days'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: const Text('Apply Filters'),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
