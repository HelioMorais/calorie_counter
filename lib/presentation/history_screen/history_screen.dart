import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/history_day_card_widget.dart';
import './widgets/history_empty_state_widget.dart';
import './widgets/history_filter_bottom_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _showBackToTop = false;
  final bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  String _selectedFilter = 'all';
  DateTimeRange? _selectedDateRange;

  // Mock data for history
  final List<Map<String, dynamic>> _historyData = [
    {
      "id": 1,
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "totalCalories": 1850,
      "targetCalories": 2000,
      "adherenceStatus": "close",
      "macronutrients": {
        "carbs": {"consumed": 220, "target": 250},
        "protein": {"consumed": 95, "target": 100},
        "fat": {"consumed": 65, "target": 70}
      },
      "waterIntake": 7,
      "waterTarget": 8,
      "foodItems": [
        {
          "name": "Aveia com Frutas Vermelhas",
          "calories": 320,
          "time": "08:30",
          "meal": "Café da Manhã"
        },
        {
          "name": "Salada de Frango Grelhado",
          "calories": 450,
          "time": "13:15",
          "meal": "Almoço"
        },
        {
          "name": "Salmão com Vegetais",
          "calories": 580,
          "time": "19:45",
          "meal": "Jantar"
        },
        {
          "name": "Iogurte Grego",
          "calories": 150,
          "time": "15:30",
          "meal": "Lanche"
        },
        {
          "name": "Mix de Castanhas",
          "calories": 200,
          "time": "10:00",
          "meal": "Lanche"
        },
        {"name": "Maçã", "calories": 95, "time": "16:30", "meal": "Lanche"}
      ]
    },
    {
      "id": 2,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "totalCalories": 2150,
      "targetCalories": 2000,
      "adherenceStatus": "over",
      "macronutrients": {
        "carbs": {"consumed": 280, "target": 250},
        "protein": {"consumed": 110, "target": 100},
        "fat": {"consumed": 85, "target": 70}
      },
      "waterIntake": 8,
      "waterTarget": 8,
      "foodItems": [
        {
          "name": "Panquecas com Xarope",
          "calories": 420,
          "time": "09:00",
          "meal": "Café da Manhã"
        },
        {
          "name": "Sanduíche de Peru",
          "calories": 380,
          "time": "12:30",
          "meal": "Almoço"
        },
        {
          "name": "Macarrão com Molho de Carne",
          "calories": 650,
          "time": "19:00",
          "meal": "Jantar"
        },
        {
          "name": "Barra de Chocolate",
          "calories": 250,
          "time": "15:00",
          "meal": "Lanche"
        },
        {
          "name": "Shake de Proteína",
          "calories": 180,
          "time": "17:30",
          "meal": "Lanche"
        },
        {"name": "Banana", "calories": 105, "time": "10:30", "meal": "Lanche"},
        {"name": "Amêndoas", "calories": 165, "time": "16:00", "meal": "Lanche"}
      ]
    },
    {
      "id": 3,
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "totalCalories": 1950,
      "targetCalories": 2000,
      "adherenceStatus": "good",
      "macronutrients": {
        "carbs": {"consumed": 245, "target": 250},
        "protein": {"consumed": 98, "target": 100},
        "fat": {"consumed": 68, "target": 70}
      },
      "waterIntake": 8,
      "waterTarget": 8,
      "foodItems": [
        {
          "name": "Tigela de Smoothie",
          "calories": 280,
          "time": "08:00",
          "meal": "Café da Manhã"
        },
        {
          "name": "Buddha Bowl de Quinoa",
          "calories": 520,
          "time": "13:00",
          "meal": "Almoço"
        },
        {
          "name": "Peixe Grelhado com Arroz",
          "calories": 480,
          "time": "19:30",
          "meal": "Jantar"
        },
        {
          "name": "Mix de Sementes",
          "calories": 220,
          "time": "15:15",
          "meal": "Lanche"
        },
        {"name": "Chá Verde", "calories": 5, "time": "16:45", "meal": "Bebida"}
      ]
    },
    {
      "id": 4,
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "totalCalories": 1650,
      "targetCalories": 2000,
      "adherenceStatus": "under",
      "macronutrients": {
        "carbs": {"consumed": 180, "target": 250},
        "protein": {"consumed": 75, "target": 100},
        "fat": {"consumed": 55, "target": 70}
      },
      "waterIntake": 6,
      "waterTarget": 8,
      "foodItems": [
        {
          "name": "Torrada com Abacate",
          "calories": 250,
          "time": "08:45",
          "meal": "Café da Manhã"
        },
        {
          "name": "Sopa de Vegetais",
          "calories": 180,
          "time": "12:45",
          "meal": "Almoço"
        },
        {
          "name": "Peito de Frango Grelhado",
          "calories": 350,
          "time": "19:15",
          "meal": "Jantar"
        },
        {"name": "Laranja", "calories": 80, "time": "15:00", "meal": "Lanche"}
      ]
    },
    {
      "id": 5,
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "totalCalories": 2050,
      "targetCalories": 2000,
      "adherenceStatus": "good",
      "macronutrients": {
        "carbs": {"consumed": 255, "target": 250},
        "protein": {"consumed": 102, "target": 100},
        "fat": {"consumed": 72, "target": 70}
      },
      "waterIntake": 8,
      "waterTarget": 8,
      "foodItems": [
        {
          "name": "Ovo Benedict",
          "calories": 380,
          "time": "09:15",
          "meal": "Café da Manhã"
        },
        {
          "name": "Salada Caesar",
          "calories": 420,
          "time": "13:30",
          "meal": "Almoço"
        },
        {
          "name": "Bife com Batatas",
          "calories": 680,
          "time": "20:00",
          "meal": "Jantar"
        },
        {
          "name": "Barra de Proteína",
          "calories": 190,
          "time": "16:00",
          "meal": "Lanche"
        }
      ]
    }
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    List<Map<String, dynamic>> filtered = List.from(_historyData);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((day) {
        final dateStr = _formatDate(day["date"] as DateTime);
        final calorieStr = day["totalCalories"].toString();
        return dateStr.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            calorieStr.contains(_searchQuery);
      }).toList();
    }

    // Apply adherence filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((day) {
        return day["adherenceStatus"] == _selectedFilter;
      }).toList();
    }

    // Apply date range filter
    if (_selectedDateRange != null) {
      filtered = filtered.where((day) {
        final dayDate = day["date"] as DateTime;
        return dayDate.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            dayDate
                .isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 1000 && !_showBackToTop) {
      setState(() {
        _showBackToTop = true;
      });
    } else if (_scrollController.offset <= 1000 && _showBackToTop) {
      setState(() {
        _showBackToTop = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Histórico atualizado'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HistoryFilterBottomSheet(
        selectedFilter: _selectedFilter,
        selectedDateRange: _selectedDateRange,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
        onDateRangeChanged: (dateRange) {
          setState(() {
            _selectedDateRange = dateRange;
          });
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dayToCheck = DateTime(date.year, date.month, date.day);

    if (dayToCheck == today) {
      return 'Hoje';
    } else if (dayToCheck == yesterday) {
      return 'Ontem';
    } else {
      final months = [
        'Jan',
        'Fev',
        'Mar',
        'Abr',
        'Mai',
        'Jun',
        'Jul',
        'Ago',
        'Set',
        'Out',
        'Nov',
        'Dez'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredHistory = _filteredHistory;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Histórico',
          style: AppTheme.lightTheme.textTheme.headlineSmall,
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por data ou calorias...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ),

          // History List
          Expanded(
            child: filteredHistory.isEmpty
                ? const HistoryEmptyStateWidget()
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: filteredHistory.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredHistory.length) {
                          return Container(
                            padding: EdgeInsets.all(4.w),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          );
                        }

                        final dayData = filteredHistory[index];
                        return HistoryDayCardWidget(
                          dayData: dayData,
                          onTap: () {
                            // Handle day card tap for expansion
                          },
                          onDelete: () {
                            _showDeleteConfirmation(dayData["id"] as int);
                          },
                          onShare: () {
                            _shareDay(dayData);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'keyboard_arrow_up',
                color: Colors.white,
                size: 24,
              ),
            )
          : null,
    );
  }

  void _showDeleteConfirmation(int dayId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Excluir Dia',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Tem certeza de que deseja excluir os dados deste dia? Esta ação não pode ser desfeita.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDay(dayId);
            },
            child: Text(
              'Excluir',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteDay(int dayId) {
    setState(() {
      _historyData.removeWhere((day) => day["id"] == dayId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dia excluído com sucesso'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareDay(Map<String, dynamic> dayData) {
    final date = _formatDate(dayData["date"] as DateTime);
    final calories = dayData["totalCalories"];
    final target = dayData["targetCalories"];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhando $date: $calories/$target kcal'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
