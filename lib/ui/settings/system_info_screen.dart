import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme.dart';

class SystemInfoScreen extends StatelessWidget {
  const SystemInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      appBar: AppBar(
        title: const Text("SYSTEM INFORMATION", style: TextStyle(fontSize: 16, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
          }
          
          final info = snapshot.data!;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoCard("App Details", [
                _buildInfoRow("App Name", info.appName),
                _buildInfoRow("Version", info.version),
                _buildInfoRow("Build Number", info.buildNumber),
                _buildInfoRow("Package Name", info.packageName),
              ]),
              const SizedBox(height: 16),
              _buildInfoCard("Environment", [
                _buildInfoRow("Status", "STABLE"),
                _buildInfoRow("Region", "Global / UK"),
                _buildInfoRow("Kernel", "Deep Cloak Engine v1.0"),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider(color: Colors.white10, height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
