import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CpuAnalysisScreen extends StatelessWidget {
  final Map cpuData;

  const CpuAnalysisScreen({super.key, required this.cpuData});

  @override
  Widget build(BuildContext context) {
    int coreCount = cpuData['coreCount'] ?? 8;
    String gov = (cpuData['governors'] is List && cpuData['governors'].isNotEmpty) 
        ? cpuData['governors'][0] 
        : "walt";

    return Scaffold(
      backgroundColor: CyberTheme.backgroundDark, 
      appBar: AppBar(
        title: const Text("CPU Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: CyberTheme.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: coreCount,
        itemBuilder: (context, index) {
          bool showClusterHeader = false;
          String clusterName = "";

          if (index == 0) {
            showClusterHeader = true;
            clusterName = "Cluster 1";
          } else if (index == 4 && coreCount > 4) {
            showClusterHeader = true;
            clusterName = "Cluster 2";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showClusterHeader)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    clusterName,
                    style: const TextStyle(color: CyberTheme.primaryAccent, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              _buildCoreDetailCard(
                index,
                index < 4 ? "Cortex-A55" : "Cortex-A78",
                "ARM",
                index < 4 ? "[0, 1, 2, 3]" : "[4, 5, 6, 7]",
                index < 4 ? "1958 MHz" : "2400 MHz",
                "691 MHz",
                gov,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoreDetailCard(
    int index,
    String type,
    String vendor,
    String cluster,
    String maxFreq,
    String minFreq,
    String governor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceDark, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CPU$index",
            style: const TextStyle(color: CyberTheme.primaryAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildInfoRow("Type", type),
          _buildInfoRow("Vendor", vendor),
          _buildInfoRow("Cluster", cluster),
          _buildInfoRow("Max frequency", maxFreq),
          _buildInfoRow("Min frequency", minFreq),
          _buildInfoRow("Governor", governor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
