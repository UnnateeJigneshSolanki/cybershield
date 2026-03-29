import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/theme_provider.dart';

class AlertSettingsScreen extends StatelessWidget {
  const AlertSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      appBar: AppBar(
        title: const Text("ALERT CONFIGURATION", style: TextStyle(fontSize: 16, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CyberTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text("Push Notifications", style: TextStyle(color: Colors.white)),
                  subtitle: const Text("Receive real-time threat intelligence", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: settings.notificationsEnabled,
                  activeColor: const Color(0xFFCCFF00),
                  onChanged: (val) => settings.setNotifications(val),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Note: Disabling notifications may delay response to critical system threats.",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
