import 'package:flutter/material.dart';
import '../../core/theme.dart';

class VulkanInfoScreen extends StatelessWidget {
  const VulkanInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.backgroundDark,
      appBar: AppBar(
        title: const Text("Vulkan Capabilities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
          _buildInfoSection("GPU Identity", {
            "Name": "Adreno (TM) 710",
            "Vendor": "Qualcomm",
            "Device ID": "0x07010000",
            "Device Type": "Integrated GPU",
            "Instance API": "1.3.0",
            "Device API": "1.1.128",
            "Driver": "Qualcomm Technologies Inc. Adreno Vulkan Driver",
            "Driver version": "512.615.98",
            "Driver Conformance": "1.2.7.2",
            "Device extensions": "89",
            "Instance extensions": "14",
          }),
          _buildInfoSection("UUIDs", {
            "Device UUID": "43510000-0600-0000-c602-6000a00602c",
            "Driver UUID": "04000000-0100-0000-0100-000000000000",
          }),
          _buildInfoSection("Memory", {
            "Device-local (shared)": "8 GB",
            "Heap 0": "7.29 GB",
            "Heap 1": "256.00 MB",
          }),
          _buildInfoSection("Limits", {
            "Max 1D image": "16384",
            "Max 2D image": "16384 x 16384",
            "Max 3D image": "2048 x 2048 x 2048",
            "Max cube image": "16384 x 16384",
            "Max array layers": "2048",
            "Uniform buffer range": "64.0 KB",
            "Storage buffer range": "128.0 MB",
            "Max anisotropy": "16",
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
