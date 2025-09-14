import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/favorite_food_card_widget.dart';
import './widgets/recent_food_item_widget.dart';
import './widgets/search_result_item_widget.dart';

class FoodLoggingScreen extends StatefulWidget {
  const FoodLoggingScreen({super.key});

  @override
  State<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
}

class _FoodLoggingScreenState extends State<FoodLoggingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _addAnimationController;
  late Animation<double> _scaleAnimation;

  bool _isSearching = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];
  final Set<String> _addedItems = {};
  int _currentCalories = 0;

  // Mock data for favorites
  final List<Map<String, dynamic>> _favoritesFoods = [
    {
      "id": "apple",
      "name": "Maçã",
      "calories": 95,
      "servingSize": "1 média",
      "imageUrl":
          "https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "sandwich",
      "name": "Sanduíche",
      "calories": 250,
      "servingSize": "1 inteiro",
      "imageUrl":
          "https://images.pexels.com/photos/1603901/pexels-photo-1603901.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  // Mock data for search database
  final List<Map<String, dynamic>> _foodDatabase = [
    {
      "id": "banana",
      "name": "Banana",
      "calories": 105,
      "servingSize": "1 média",
      "imageUrl":
          "https://images.pexels.com/photos/61127/pexels-photo-61127.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "chicken_breast",
      "name": "Peito de Frango",
      "calories": 165,
      "servingSize": "100g",
      "imageUrl":
          "https://images.pexels.com/photos/616354/pexels-photo-616354.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "rice",
      "name": "Arroz Branco",
      "calories": 130,
      "servingSize": "1 xícara cozida",
      "imageUrl":
          "https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "broccoli",
      "name": "Brócolis",
      "calories": 25,
      "servingSize": "1 xícara",
      "imageUrl":
          "https://images.pexels.com/photos/47347/broccoli-vegetable-food-healthy-47347.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "salmon",
      "name": "Salmão",
      "calories": 206,
      "servingSize": "100g",
      "imageUrl":
          "https://images.pexels.com/photos/725991/pexels-photo-725991.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  // Mock recent foods
  final List<Map<String, dynamic>> _recentFoods = [
    {
      "id": "oatmeal",
      "name": "Aveia",
      "calories": 150,
      "servingSize": "1 xícara",
      "timestamp": "Hoje, 8:30",
    },
    {
      "id": "greek_yogurt",
      "name": "Iogurte Grego",
      "calories": 100,
      "servingSize": "1 pote",
      "timestamp": "Ontem, 14:15",
    },
  ];

  @override
  void initState() {
    super.initState();
    _addAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _addAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _addAnimationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults.clear();
        _isLoading = false;
      } else {
        _isLoading = true;
      }
    });

    if (query.isNotEmpty) {
      // Simulate search delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _searchController.text == query) {
          setState(() {
            _searchResults = _foodDatabase
                .where((food) => (food["name"] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
            _isLoading = false;
          });
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _isSearching = false;
      _searchResults.clear();
      _isLoading = false;
    });
  }

  void _addFood(Map<String, dynamic> food) {
    if (_addedItems.contains(food["id"])) return;

    HapticFeedback.lightImpact();
    _addAnimationController.forward().then((_) {
      _addAnimationController.reverse();
    });

    setState(() {
      _addedItems.add(food["id"] as String);
      _currentCalories += food["calories"] as int;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food["name"]} adicionado (+${food["calories"]} kcal)'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );

    // Remove from added items after 3 seconds to allow re-adding
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _addedItems.remove(food["id"]);
        });
      }
    });
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Procurar comida...',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Favoritos',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favoritesFoods.length,
            itemBuilder: (context, index) {
              final food = _favoritesFoods[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _favoritesFoods.length - 1 ? 12 : 0,
                ),
                child: FavoriteFoodCardWidget(
                  food: food,
                  onAdd: () => _addFood(food),
                  isAdded: _addedItems.contains(food["id"]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_searchResults.isEmpty && _isSearching) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Resultados da Busca',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final food = _searchResults[index];
            return SearchResultItemWidget(
              food: food,
              onAdd: () => _addFood(food),
              isAdded: _addedItems.contains(food["id"]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentFoodsSection() {
    if (_isSearching) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Comidas Recentes',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentFoods.length,
          itemBuilder: (context, index) {
            final food = _recentFoods[index];
            return RecentFoodItemWidget(
              food: food,
              onAdd: () => _addFood(food),
              isAdded: _addedItems.contains(food["id"]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(3, (index) => _buildSkeletonCard()),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum resultado encontrado',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar com termos diferentes',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adicionar Comida'),
            Text(
              'Total: $_currentCalories kcal',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Base de dados nutricional offline—somente modo demo',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isSearching) ...[
                      _buildFavoritesSection(),
                      const SizedBox(height: 24),
                      _buildRecentFoodsSection(),
                    ] else
                      _buildSearchResults(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
