import 'package:flutter/material.dart';
import '../../core/theme.dart';

class OpenGlInfoScreen extends StatelessWidget {
  final Map gpuData;
  const OpenGlInfoScreen({super.key, required this.gpuData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.backgroundDark,
      appBar: AppBar(
        title: const Text("OpenGL ES Capabilities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
          _buildSectionHeader("Renderer Information"),
          _buildInfoCard([
            _buildInfoRow("Version", gpuData["openglVersion"] ?? "OpenGL ES 3.2"),
            _buildInfoRow("Renderer", gpuData["renderer"] ?? "Unknown"),
            _buildInfoRow("Vendor", gpuData["vendor"] ?? "Unknown"),
            _buildInfoRow("Shading Language", "OpenGL ES GLSL ES 3.20"),
          ]),
          
          const SizedBox(height: 16),
          
          _buildSectionHeader("Highlights"),
          _buildInfoCard([
            _buildInfoRow("ASTC textures", "Yes"),
            _buildInfoRow("ETC2 textures", "Yes"),
            _buildInfoRow("ETC1 textures", "Yes"),
            _buildInfoRow("sRGB textures/fbos", "Yes"),
            _buildInfoRow("Texture storage", "Yes"),
            _buildInfoRow("Timer queries", "Yes"),
            _buildInfoRow("Compute shaders", "Yes"),
            _buildInfoRow("Geometry shaders", "Yes"),
            _buildInfoRow("Tessellation shaders", "Yes"),
          ]),

          const SizedBox(height: 16),

          _buildSectionHeader("Limits"),
          _buildInfoCard([
            _buildInfoRow("Max Texture Size", "16384"),
            _buildInfoRow("Max Viewport Dims", "16384 x 16384"),
            _buildInfoRow("Max Vertex Uniform Vectors", "1024"),
            _buildInfoRow("Max Fragment Uniform Vectors", "1024"),
          ]),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: CyberTheme.primaryAccent, // ✨ UPDATED: Green to Cyan
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
