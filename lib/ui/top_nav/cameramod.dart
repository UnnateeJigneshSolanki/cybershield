import 'package:flutter/material.dart';
import '../../services/native_camera_service.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  State<CameraPage> createState() => _CameraPageState();
}
class _CameraPageState extends State<CameraPage> {
  final NativeCameraService _native = NativeCameraService();
  List<Map<String, dynamic>> _cameraInfo = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadCameraInfo();
  }
  Future<void> _loadCameraInfo() async {
    try {
      final data = await _native.getCameraInfo();

      if (!mounted) return;
      setState(() {
        _cameraInfo = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00E5FF);
    const bg = Color(0xFF00012B);
    if (_loading) {
      return const Scaffold(
        backgroundColor: bg,
        body: Center(
          child: CircularProgressIndicator(color: accent),
        ),
      );
    }
    if (_cameraInfo.isEmpty) {
      return const Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Text( "No camera hardware detected",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _cameraInfo.length,
          itemBuilder: (context, index) {
            return _CameraCard(data: _cameraInfo[index]);
          },
        ),
      ),
    );
  }
}
class _CameraCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _CameraCard({required this.data});
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00E5FF);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0D3A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${data['facing']}",
            style: const TextStyle(
              color: accent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.camera_alt_rounded,
                size: 60,
                color: accent,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data['megapixels'] ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text( data['apertures'] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _InfoTile("Resolution", data['resolution'], tileWidth),
                  _InfoTile("Focal length", data['focalLengths'], tileWidth),
                  _InfoTile("Sensor width", data['sensorWidthMm'] != null
                          ? "${(data['sensorWidthMm'] as num).toStringAsFixed(2)} mm" : "-",
                      tileWidth),
                  _InfoTile("Sensor height", data['sensorHeightMm'] != null
                          ? "${(data['sensorHeightMm'] as num).toStringAsFixed(2)} mm" : "-",
                      tileWidth),
                  _InfoTile("Pixel size", data['pixelSize'], tileWidth),
                  _InfoTile("Sensor diagonal", data['sensorDiagonal'], tileWidth),
                  _InfoTile("Min focus", data['minFocusDistance'], tileWidth),
                  _InfoTile("Flash", data['flashSupport'], tileWidth),
                  _InfoTile("OIS", data['oisSupport'], tileWidth),
                  _InfoTile("RAW capture",(data['rawSupport'] ?? false) ? "Yes" : "No", tileWidth),
                  _InfoTile("Max ISO", data['maxISO'], tileWidth),
                  _InfoTile("Max FPS", data['maxFPS'], tileWidth),
                  _InfoTile("Max video", data['maxVideo'], tileWidth),
                  _InfoTile("Max zoom", "${data['maxZoom']}x", tileWidth),
                  _InfoTile("Face detect", data['faceDetection'], tileWidth),
                  _InfoTile("Hardware level", data['hardwareLevel'], tileWidth),
                  _InfoTile("Orientation", "${data['orientation']}°", tileWidth),

                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
class _InfoTile extends StatelessWidget {
  final String label;
  final dynamic value;
  final double width;
  const _InfoTile(this.label, this.value, this.width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(value?.toString() ?? "-",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}