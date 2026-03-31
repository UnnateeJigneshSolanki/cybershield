import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_settings/app_settings.dart';
import '../../core/theme.dart';
import 'cpu_analysis_screen.dart';
import 'vulkan_info_screen.dart';
import 'opengl_info_screen.dart';
import 'disk_partition_screen.dart';
import 'bluetooth_info_screen.dart';

class HardwarePage extends StatefulWidget {
  const HardwarePage({super.key});
  @override
  State<HardwarePage> createState() => _HardwarePageState();
}
class _HardwarePageState extends State<HardwarePage> {
  static const platform = MethodChannel("com.cybershield/hardware");
  static const Color accentColor = CyberTheme.primaryAccent; 
  Map cpu = {};
  Map gpu = {};
  Map display = {};
  Map memory = {};
  Map storage = {};
  Map bluetooth = {};
  Map audio = {};
  Map sensors = {};
  Map usb = {};
  Map nfc = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHardware();
  }

  Future<void> loadHardware() async {

    await Future.delayed(const Duration(milliseconds: 500));
    try {
      cpu = Map.from(await platform.invokeMethod("getDeepCpuInfo"));
      gpu = Map.from(await platform.invokeMethod("getGpuFullInfo"));
      display = Map.from(await platform.invokeMethod("getDeepDisplayInfo"));
      memory = Map.from(await platform.invokeMethod("getDeepMemoryInfo"));
      storage = Map.from(await platform.invokeMethod("getDeepStorageInfo"));
      bluetooth = Map.from(await platform.invokeMethod("getBluetoothHardware"));
      audio = Map.from(await platform.invokeMethod("getAudioHardware"));
      sensors = Map.from(await platform.invokeMethod("getSensorHardware"));
      usb = Map.from(await platform.invokeMethod("getUsbHardware"));
      nfc = Map.from(await platform.invokeMethod("getNfcHardware"));
    } catch (e) {
      debugPrint("Hardware error: $e");
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(color: accentColor));
    }

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildProcessorSection(),
          _buildGpuSection(),
          _buildGraphicsApiSection(),
          _buildDisplaySection(),
          _buildMemorySection(),
          _buildStorageSection(),
          _buildBluetoothSection(),
          _buildAudioSection(),
          _buildOtherSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    Widget? trailing,
    Widget? actionButton,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                    if (trailing != null) trailing,
                  ],
                ),
                const SizedBox(height: 16),
                ...children,
              ],
            ),
          ),
          if (actionButton != null) ...[
            const Divider(color: Colors.white10, height: 1),
            actionButton,
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 18),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid(Map<String, String> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        String key = items.keys.elementAt(index);
        String value = items.values.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                key.toUpperCase(),
                style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.1)
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    );
  }

  Widget _buildProcessorSection() {
    return _buildSectionCard(
      title: "Processor",
      actionButton: _buildActionButton("CPU Analysis", Icons.memory, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CpuAnalysisScreen(cpuData: cpu)));
      }),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.memory, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cpu["hardware"] ?? "Unknown Processor", style: const TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip("${cpu["coreCount"] ?? "?"} cores"),
                      const SizedBox(width: 8),
                      _buildChip(cpu["architecture"] ?? "64-bit"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text("CPU Configuration", style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 12),
        _buildCpuConfigRow("Cores 0-3", "691-1958 MHz", accentColor),
        _buildCpuConfigRow("Cores 4-7", "691-2400 MHz", accentColor.withOpacity(0.7)),
        const SizedBox(height: 24),
        _buildInfoGrid({
          "Vendor": cpu["vendor"] ?? "Unknown",
          "Hardware": cpu["hardware"] ?? "Unknown",
          "Architecture": cpu["architecture"] ?? "ARMv8",
          "ABI": "arm64-v8a",
          "Governor": (cpu["governors"] is List && cpu["governors"].isNotEmpty) ? cpu["governors"][0] : "walt",
        }),
      ],
    );
  }

  Widget _buildCpuConfigRow(String label, String freq, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Row(
            children: List.generate(4, (i) => Container(
              width: 8, height: 8,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            )),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(freq, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildGpuSection() {
  return _buildSectionCard(
    title: "GPU",
    children: [
      Row(
        children: [
          const Icon(Icons.grid_view, color: Colors.white, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gpu["renderer"] ?? "Scanning Hardware...",
                  style: TextStyle(
                    color: gpu["renderer"] == null ? Colors.white24 : accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  gpu["vendor"] ?? "Vendor Information",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildGraphicsApiSection() {
    return Column(
      children: [
        _buildSectionCard(
          title: "Graphics APIs",
          actionButton: _buildActionButton("Vulkan Capabilities", Icons.auto_awesome, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const VulkanInfoScreen()));
          }),
          children: [
            const Text("Vulkan API version", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            const Text("1.1.128", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        _buildSectionCard(
          title: "OpenGL",
          actionButton: _buildActionButton("OpenGL ES Capabilities", Icons.auto_awesome, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => OpenGlInfoScreen(gpuData: gpu)));
          }),
          children: [
            Text(gpu["openglVersion"] ?? "OpenGL ES 3.2", style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildDisplaySection() {
    final w = int.tryParse(display["physicalWidth"].toString()) ?? 1080;
    final h = int.tryParse(display["physicalHeight"].toString()) ?? 2400;
    return _buildSectionCard(
      title: "Display",
      trailing: IconButton( // ✨ UPDATED: Added Settings Icon
        icon: const Icon(Icons.settings, color: Colors.white54, size: 20),
        onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.display),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.smartphone, color: Colors.white, size: 64),
            const SizedBox(width: 20),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ Text("$w x $h",
              style: const TextStyle(
              color: accentColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          
            Text("${(double.tryParse(display["refreshRate"].toString()) ?? 60).toStringAsFixed(1)} Hz • ${display["averagePpi"]?.toInt() ?? 395} ppi",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
             ),
             
        ],
      ),
    ),
  ],
),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            _buildChip("${(double.tryParse(display["screenInches"].toString()) ?? 6.67).toStringAsFixed(2)}\""),
            _buildChip("xhdpi"),
             ],
             ),
        const SizedBox(height: 24),
        _buildInfoGrid({
          "Current resolution": "$w x $h",
          "Screen size": "${(double.tryParse(display["screenInches"].toString()) ?? 6.67).toStringAsFixed(2)} in",
          "Aspect ratio": "20:9",
          "HDR support": "No",
          "Density": "${display["densityDpi"] ?? 400} dpi",
        }),
      ],
    );
  }

  Widget _buildMemorySection() {
    final total = (memory["MemTotal"] ?? 8589934592) / 1073741824;
    final avail = (memory["MemAvailable"] ?? 3435973836) / 1073741824;
    final used = total - avail;
    return _buildSectionCard(
      title: "Memory",
      trailing: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white54, size: 20),
        onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.settings),
      ),
      children: [
        _buildDetailTextRow("RAM size", "${total.toInt()} GB"),
        const SizedBox(height: 16),
        const Text("RAM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${used.toStringAsFixed(2)} GB used", style: const TextStyle(color: Colors.white54, fontSize: 12)),
            Text("${total.toStringAsFixed(2)} GB total", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        _buildProgressBar(used / total, accentColor),
        const SizedBox(height: 4),
        Align(alignment: Alignment.centerRight, child: Text("${avail.toStringAsFixed(2)} GB free", style: const TextStyle(color: Colors.white54, fontSize: 12))),
        const SizedBox(height: 16),
        const Text("ZRAM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("2.16 GB used", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const Text("5.87 GB total", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        _buildProgressBar(2.16 / 5.87, accentColor),
        const SizedBox(height: 4),
        const Align(alignment: Alignment.centerRight, child: Text("3.71 GB free", style: TextStyle(color: Colors.white54, fontSize: 12))),
      ],
    );
  }

  Widget _buildStorageSection() {
    final total = (storage["dataTotal"] ?? 137438953472) / 1073741824;
    final used = (storage["dataUsed"] ?? 62642585600) / 1073741824;
    return _buildSectionCard(
      title: "Storage",
      trailing: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white54, size: 20),
        onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.internalStorage),
      ),
      actionButton: _buildActionButton("Disk partitions", Icons.storage, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DiskPartitionScreen(storageData: storage)));
      }),
      children: [
        _buildInfoGrid({
          "Size": "${total.toInt()} GB",
          "Type": "UFS",
        }),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${used.toStringAsFixed(2)} GB used", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text("${total.toInt()} GB total", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        _buildProgressBar(used / total, accentColor),
        const SizedBox(height: 12),
        _buildStorageDetailItem("Apps and data", "47.06 GB", accentColor),
        _buildStorageDetailItem("System", "11.28 GB", accentColor),
        _buildStorageDetailItem("Free", "${(total - used).toStringAsFixed(2)} GB", Colors.white12),
        const SizedBox(height: 24),
        Text("Internal storage", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDetailTextRow("Filesystem", "f2fs"),
        _buildDetailTextRow("Block size", "4 kB"),
        const SizedBox(height: 16),
        const Text("/data", style: TextStyle(color: Colors.white, fontSize: 14)),
        _buildProgressBar(used / total, accentColor),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${used.toStringAsFixed(2)} GB used", style: const TextStyle(color: Colors.white54, fontSize: 11)),
            Text("${(total - used).toStringAsFixed(2)} GB free", style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildBluetoothSection() {
    return _buildSectionCard(
      title: "Bluetooth",
      trailing: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white54, size: 20),
        onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
      ),
      children: [
        InkWell( // ✨ UPDATED: Made "SHOW" clickable
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => BluetoothInfoScreen(bluetoothData: bluetooth)));
          },
          child: _buildDetailTextRow("Bluetooth support", "SHOW", valueColor: accentColor),
        ),
      ],
    );
  }

  Widget _buildAudioSection() {
    return _buildSectionCard(
      title: "Audio",
      children: [
        _buildCheckRow("Low latency audio", false),
        _buildCheckRow("Pro audio support", false),
        _buildCheckRow("MIDI support", true),
        _buildCheckRow("Unprocessed audio source", true),
        const SizedBox(height: 20),
        Text("Output", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDetailTextRow("Sample rate", "48 kHz"),
        _buildDetailTextRow("Buffer size", "192 Frames"),
        _buildDetailTextRow("Bit depth", "16-bit"),
        _buildDetailTextRow("Output routes", "Speaker"),
        const SizedBox(height: 16),
        const Text("Codecs", style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
          child: const Text(
            "Audio: AC3, E-AC3, AAC, AMR-WB, FLAC, PCM A-law, PCM μ-law, GSM, MP3, Opus, Raw PCM, Vorbis\nVideo: H.264 / AVC, H.265 / HEVC, VP9, MPEG-4 Visual, VP8\nOther: ac4, 3gpp, av01",
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherSection() {
    return _buildSectionCard(
      title: "Other",
      children: [
        _buildCheckRow("USB host support", true),
        _buildCheckRow("USB accessory support", true),
        _buildCheckRow("Fingerprint (Goodix)", true),
        _buildCheckRow("Face detection", true),
      ],
    );
  }

  Widget _buildProgressBar(double percent, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: percent,
        backgroundColor: Colors.white10,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: 12,
      ),
    );
  }

  Widget _buildDetailTextRow(String label, String value, {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStorageDetailItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 12),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String label, bool check) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(check ? Icons.check_circle : Icons.cancel, color: check ? accentColor : Colors.white24, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
