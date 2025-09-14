import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/food_logging_screen/food_logging_screen.dart';
import '../presentation/history_screen/history_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String foodLoggingScreen = '/food-logging-screen';
  static const String historyScreen = '/history-screen';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    foodLoggingScreen: (context) => const FoodLoggingScreen(),
    historyScreen: (context) => const HistoryScreen(),
    settingsScreen: (context) => const SettingsScreen(),
  };
}
