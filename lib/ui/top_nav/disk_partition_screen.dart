import 'package:flutter/material.dart';
import '../../core/theme.dart';

class DiskPartitionScreen extends StatelessWidget {
  final Map storageData;
  const DiskPartitionScreen({super.key, required this.storageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.backgroundDark,
      appBar: AppBar(
        title: const Text("Disk Partitions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: CyberTheme.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPartitionCard("/data", "User Data", storageData["dataUsed"] ?? 0, storageData["dataTotal"] ?? 0, CyberTheme.primaryAccent),
          _buildPartitionCard("/system", "System OS", 11.28 * 1073741824, 12.0 * 1073741824, Colors.blue),
          _buildPartitionCard("/cache", "Cache", 256 * 1024 * 1024, 512 * 1024 * 1024, Colors.orange),
          _buildPartitionCard("/vendor", "Vendor Files", 800 * 1024 * 1024, 1024 * 1024 * 1024, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildPartitionCard(String mount, String label, dynamic used, dynamic total, Color color) {
    double usedGB = (used is num ? used.toDouble() : 0) / 1073741824;
    double totalGB = (total is num ? total.toDouble() : 0) / 1073741824;
    double percent = totalGB > 0 ? (usedGB / totalGB) : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceDark, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(mount, style: const TextStyle(color: CyberTheme.primaryAccent, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white10,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${usedGB.toStringAsFixed(2)} GB used", style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text("${totalGB.toStringAsFixed(2)} GB total", style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
