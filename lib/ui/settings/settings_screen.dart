import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'alert_settings_screen.dart';
import 'system_info_screen.dart';

const Color cyberGreen = Color(0xFF00E5FF);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "SETTINGS",
          style: TextStyle(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),

          const SizedBox(height: 20),

          _buildSectionHeader("SYSTEM PREFERENCES"),

          _buildTile(
            Icons.notifications_active_outlined,
            "Alert Configurations",
            "Manage push notifications for threats",
            () {
              debugPrint("Navigating to Alert Configurations");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlertSettingsScreen()),
              );
            },
          ),

          const Divider(color: Colors.white10, indent: 16, endIndent: 16),

          _buildSectionHeader("ABOUT SYSTEM"),

          _buildTile(
            Icons.info_outline,
            "System Information",
            "View build details and diagnostics",
            () {
              debugPrint("Navigating to System Information");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SystemInfoScreen()),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─────────────────────────
  // UI HELPERS
  // ─────────────────────────

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: CyberTheme.surface,
      child:const Row(
        children: [
           CircleAvatar(
            radius: 30,
            backgroundColor: cyberGreen,
            child: Icon(
              Icons.terminal,
              color: Colors.black,
              size: 30,
            ),
          ),
           SizedBox(width: 15),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DeepCytes Cyber Labs UK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: cyberGreen,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
    String sub,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {
          ("Tile tapped: $title"); // Debugging tap detection
          onTap();
        },
      ),
    );
  }
}
