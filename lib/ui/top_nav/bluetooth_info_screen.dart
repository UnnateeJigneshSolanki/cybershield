import 'package:flutter/material.dart';
import '../../core/theme.dart';

class BluetoothInfoScreen extends StatelessWidget {
  final Map bluetoothData;
  const BluetoothInfoScreen({super.key, required this.bluetoothData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.backgroundDark,
      appBar: AppBar(
        title: const Text("Bluetooth Support", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
          _buildInfoSection("Bluetooth Identity", {
            "Adapter Name": bluetoothData["name"] ?? "Bluetooth Adapter",
            "State": bluetoothData["state"] ?? "On",
            "Hardware Address": bluetoothData["address"] ?? "00:00:00:00:00:00",
          }),
          _buildInfoSection("Technical Specs", {
            "LE Supported": bluetoothData["leSupported"]?.toString() ?? "Yes",
            "Multi-Advertisement": bluetoothData["multiAdvertisement"]?.toString() ?? "Yes",
            "Periodic Advertising": bluetoothData["periodicAdvertising"]?.toString() ?? "No",
            "High Power": bluetoothData["highPower"]?.toString() ?? "Yes",
          }),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, Map<String, String> data) {
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
          Text(title, style: const TextStyle(color: CyberTheme.primaryAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...data.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(e.key, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ),
                Expanded(
                  child: Text(
                    e.value,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
