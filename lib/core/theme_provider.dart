import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _notificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeProvider() {
    _loadSettings();
  }

  // Toggle Theme logic
  Future<void> toggleTheme(bool isDark) async {
    debugPrint("ThemeProvider: Toggling theme to ${isDark ? 'Dark' : 'Light'}");
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    
    notifyListeners();
  }

  // Alert/Notification logic
  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme
    final isDark = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    // Load Notifications
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    
    debugPrint("ThemeProvider: Settings loaded. DarkMode: $isDark");
    notifyListeners();
  }
}
