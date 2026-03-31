import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../core/theme.dart';
import '../../core/cpu_provider.dart';
import '../../core/battery_provider.dart';
import 'singlecoregraph.dart';
import 'multicoregraph.dart';

class BenchmarksScreen extends StatefulWidget {
  const BenchmarksScreen({super.key});

  @override
  State<BenchmarksScreen> createState() => _BenchmarksScreenState();
}

class _BenchmarksScreenState extends State<BenchmarksScreen> {

  bool _isRunning = false;
  bool _isFinished = false;

  double _progress = 0;

  String _currentTask = "Ready to test device performance";

  int cpuSingleScore = 0;
  int cpuMultiScore = 0;
  int memoryScore = 0;
  int mathScore = 0;
  int finalScore = 0;

  String deviceName = "Unknown";
  int cpuCores = 0;
  double benchmarkTime = 0;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {

    final info = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      deviceName = "${android.manufacturer} ${android.model}";
    }

    cpuCores = Platform.numberOfProcessors;

    if (mounted) setState(() {});
  }

  Future<int> _measure(Future Function() task) async {

    int total = 0;

    for (int i = 0; i < 2; i++) {
      final sw = Stopwatch()..start();
      await task();
      sw.stop();
      total += sw.elapsedMilliseconds;
    }

    return (total / 2).round();
  }

  Future<void> _runBenchmark() async {
    setState(() {
      _isRunning = true;
      _isFinished = false;
      _progress = 0.15;
      _currentTask = "Running CPU Single Core Test";
    });
    final totalTimer = Stopwatch()..start();
    int singleTime =
        await _measure(() => compute(_cpuIntegerTask, 600000));
    cpuSingleScore = (1000000 / singleTime).round();

    if (!mounted) return;

    setState(() {
      _progress = 0.40;
      _currentTask = "Running CPU Multi Core Test";
    });
    int cores = max(2, Platform.numberOfProcessors);
    int multiTime = await _measure(() async {
      List<Future> tasks = [];
      for (int i = 0; i < cores; i++) {
        tasks.add(compute(_cpuIntegerTask, 600000));
      }
      await Future.wait(tasks);
    });
    cpuMultiScore = ((1000000 / multiTime) * cores).round();
    if (!mounted) return;

    setState(() {
      _progress = 0.65;
      _currentTask = "Running Floating Point Test";
    });
    int mathTime =
        await _measure(() => compute(_cpuFloatTask, 12000000));
    mathScore = (1000000 / mathTime).round();

    if (!mounted) return;

    setState(() {
      _progress = 0.90;
      _currentTask = "Running Memory Test";
    });
    int memTime =
        await _measure(() => compute(_memoryTask, 8000000));
    memoryScore = (1000000 / memTime).round();
    totalTimer.stop();
    benchmarkTime = totalTimer.elapsedMilliseconds / 1000;

    if (!mounted) return;
    setState(() {
      _progress = 0.9;
      _currentTask = "Calculating Final Score";
    });
    finalScore =
        ((cpuSingleScore + cpuMultiScore + mathScore + memoryScore) / 4)
            .round();
    final box = Hive.box('benchmarkLogs');
    await box.add({
      'score': finalScore,
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isFinished = true;
      _progress = 1;
      _currentTask = "Benchmark Completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      appBar: AppBar(
        title: const Text("Benchmarks", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.speed,
                size: 80,
                color: _isRunning || _isFinished
                    ? CyberTheme.primaryAccent
                    : Colors.white24,
              ),
              const SizedBox(height: 30),
              Text( _currentTask,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _isRunning
                        ? CyberTheme.primaryAccent
                        : Colors.white70,
                    fontSize: 16),
              ),

              const SizedBox(height: 20),
              if (_isRunning) ...[
                LinearProgressIndicator(
                    value: _progress,
                    color: CyberTheme.primaryAccent,
                    backgroundColor: Colors.white10,
                    minHeight: 8),
                const SizedBox(height: 10),
                Text("${(_progress * 100).toInt()}%",
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 30),
                _buildLiveMetricsPanel(),
              ],
              if (_isFinished) ...[
                _scoreRow("CPU SINGLE CORE", cpuSingleScore),
                _scoreRow("CPU MULTI CORE", cpuMultiScore),
                _scoreRow("FLOATING POINT", mathScore),
                _scoreRow("MEMORY", memoryScore),
                const Divider(color: Colors.white24, height: 40),
                const Text("FINAL SCORE",
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
                Text(
                  finalScore.toString(),
                  style: const TextStyle(
                      color: CyberTheme.primaryAccent,
                      fontSize: 56,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("DEVICE INFORMATION",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      letterSpacing: 1.5),
                ),
                const SizedBox(height: 10),
                _scoreRow("DEVICE", deviceName),
                _scoreRow("CPU CORES", cpuCores),
                _scoreRow("BENCHMARK TIME", "${benchmarkTime.toStringAsFixed(2)} sec"),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (_) => SingleCoreGraph(
                          userScore: cpuSingleScore,
                          deviceName: deviceName,
                        ),
                      ),
                    );
                  },
                  child: const Text("Compare Single-Core Performance"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (_) => MultiCoreGraph(
                          userScore: cpuMultiScore,
                          deviceName: deviceName,
                        ),
                      ),
                    );
                  },
                  child: const Text("Compare Multi-Core Performance"),
                ),
              ],
              const SizedBox(height: 40),
              if (!_isRunning)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CyberTheme.primaryAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    onPressed: _runBenchmark,
                    child: Text(
                        _isFinished ? "RUN AGAIN" : "START BENCHMARK",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              const SizedBox(height: 40),
              if (!_isRunning) _buildHistoryPanel()
            ],
          ),
        ),
      ),
    );
  }
  Widget _scoreRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value.toString(),
              style: const TextStyle(
                  color: CyberTheme.primaryAccent,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildLiveMetricsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CyberTheme.primaryAccent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Consumer<CpuProvider>(
            builder: (context, cpuProv, child) {
              int freq =
                  cpuProv.cpuFreqs.isNotEmpty ? cpuProv.cpuFreqs[0] : 0;
              return _metricItem(Icons.memory, "CPU CLOCK", "$freq MHz");
            },
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          Consumer<BatteryProvider>(
            builder: (context, batProv, child) {
              double temp = batProv.batteryData['temperature'] ?? 0;
              return _metricItem(
                  Icons.thermostat,
                  "THERMAL",
                  "${temp.toStringAsFixed(1)}°C");
            },
          ),
        ],
      ),
    );
  }

  Widget _metricItem(IconData icon, String label, String value) {

    return Column(
      children: [

        Icon(icon, color: Colors.white54, size: 20),

        const SizedBox(height: 6),

        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 10)),
      ],
    );
  }

  Widget _buildHistoryPanel() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('benchmarkLogs').listenable(),
      builder: (context, Box box, _) {
        if (box.isEmpty) return const SizedBox.shrink();
        final logs = box.values.toList().reversed.take(5).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PREVIOUS LOGS",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            ...logs.map((log) {
              final Map data = log as Map;
              final int score = data['score'];
              final DateTime time =
                  DateTime.parse(data['timestamp']);
              final String formatted =
                  DateFormat('MMM dd, yyyy • HH:mm').format(time);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: CyberTheme.surface,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatted,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12)),
                    Text(score.toString(),
                        style: const TextStyle(
                            color: CyberTheme.primaryAccent,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              );
            })
          ],
        );
      },
    );
  }
}

int _cpuIntegerTask(int limit) {
  int primes = 0;
  for (int i = 2; i < limit; i++) {
    bool isPrime = true;
    for (int j = 2; j * j <= i; j++) {
      if (i % j == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) primes++;
  }
  return primes;
}

double _cpuFloatTask(int limit) {
  double result = 0.0;
  for (int i = 1; i < limit; i++) {
    double x = i.toDouble();
    result += sin(x) * cos(x);
    result += sqrt(x);
    result += x / (x + 1.0);
    result += x * 0.123456;
  }
  return result;
}

int _memoryTask(int size) {
  List<int> buffer = List.generate(size, (i) => i);
  int sum = 0;
  for (int i = 0; i < size; i++) {
    buffer[i] = buffer[i] * 3 + 1;
  }
  for (int i = 0; i < size; i++) {
    sum += buffer[i];
  }
  return sum;
}