import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'dart:math' as math;

class WidgetsScreen extends StatefulWidget {
  const WidgetsScreen({super.key});

  @override
  State<WidgetsScreen> createState() => _WidgetsScreenState();
}

class _WidgetsScreenState extends State<WidgetsScreen> with TickerProviderStateMixin {
  final Color widgetCyan = const Color(0xFF00E5FF);
  final Color hudBlueTransparent = const Color(0xFF00E5FF).withValues(alpha: 0.08);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      appBar: AppBar(
        title: const Text(
          "DEEP CLOAK WIDGETS",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: Text(
              "BETA STAGE HUD PREVIEWS",
              style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 30),

          _buildPreviewContainer(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _stripItem("[⚙️] RAM:", " 68%"),
                const Text("|", style: TextStyle(color: Colors.white10)),
                _stripItem("[⚡] BAT:", " 85%"),
                const Text("|", style: TextStyle(color: Colors.white10)),
                _stripItem("[🌡️]", " 36°C"),
                _buildRotatingSyncIcon(),
              ],
            ),
          ),
          _buildCaption("The Cyber Strip (4x1) - Glass HUD"),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildCircularNode(
                  title: "[⚡] PWR_CELL",
                  centerValue: "85%",
                  bottomText: "36°C",
                  progress: 0.85,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCircularNode(
                  title: "[⚙️] SYS_MEM",
                  centerValue: "68%",
                  bottomText: "Storage: 50%",
                  progress: 0.68,
                ),
              ),
            ],
          ),
          _buildCaption("Power & Memory Nodes (2x2)"),

          const SizedBox(height: 16),

          Center(
            child: _buildPreviewContainer(
              height: 160,
              width: 160,
              child: Stack(
                children: [
                  Align(alignment: Alignment.topRight, child: _buildRotatingSyncIcon(size: 16)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("[🌐] NET_LINK",
                          style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      Column(
                        children: [
                          const Text("IP ADDRESS",
                              style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("192.168.1.45",
                              style: TextStyle(color: widgetCyan, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Text("Traffic: 1.2 GB",
                          style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildCaption("Network Uplink (2x2)"),

          const SizedBox(height: 16),

          _buildPreviewContainer(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min, // FIX
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("THU, MAR 12",
                            style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                        const Text("01:05",
                            style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    _buildRotatingSyncIcon(size: 24),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(Icons.smartphone, color: widgetCyan, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Device",
                            style: TextStyle(color: widgetCyan, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("CPH2423",
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const Text("Uptime 22h 33m",
                            style: TextStyle(color: Colors.white54, fontSize: 11)),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildMasterProgress("RAM", "68%", 0.68),
                    const SizedBox(width: 16),
                    _buildMasterProgress("STORAGE", "88%", 0.88),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBottomStat("BATTERY", "40%", Icons.battery_charging_full),
                    _buildBottomStat("TEMP", "36°C", null),
                    _buildBottomStat("DATA", "11.1 GB", null),
                  ],
                )
              ],
            ),
          ),
          _buildCaption("The Master Console - Full HUD"),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: widgetCyan.withValues(alpha: 0.2),
                  side: BorderSide(color: widgetCyan),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Long-press your Home Screen to add widgets!")));
              },
              child: const Text("HOW TO ADD WIDGETS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPreviewContainer({required Widget child, required double height, double? width}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: hudBlueTransparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widgetCyan.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: widgetCyan.withValues(alpha: 0.05), blurRadius: 15, spreadRadius: 2)
          ]),
      child: child,
    );
  }

  Widget _buildRotatingSyncIcon({double size = 20}) {
    return _AutoRotatingIcon(icon: Icons.sync, color: widgetCyan, size: size);
  }

  Widget _buildCaption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(text.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.2)),
    );
  }

  Widget _stripItem(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: widgetCyan, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCircularNode({required String title, required String centerValue, required String bottomText, required double progress}) {
    return _buildPreviewContainer(
      height: 160,
      child: Stack(
        children: [
          Align(alignment: Alignment.topRight, child: _buildRotatingSyncIcon(size: 18)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(value: progress, color: widgetCyan, backgroundColor: Colors.white10, strokeWidth: 5),
                    Center(child: Text(centerValue, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              Text(bottomText, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasterProgress(String label, String value, double progress) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: progress, color: widgetCyan, backgroundColor: Colors.white10),
        ],
      ),
    );
  }

  Widget _buildBottomStat(String label, String val, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        const SizedBox(height: 2),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: widgetCyan, size: 14),
              const SizedBox(width: 4)
            ],
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}

class _AutoRotatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _AutoRotatingIcon({required this.icon, required this.color, required this.size});

  @override
  State<_AutoRotatingIcon> createState() => _AutoRotatingIconState();
}

class _AutoRotatingIconState extends State<_AutoRotatingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}