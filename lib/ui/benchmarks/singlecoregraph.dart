import 'package:flutter/material.dart';
import '../../models/cpucores.dart';
import '../../core/theme.dart';

class SingleCoreGraph extends StatelessWidget {
  final int userScore;
  final String deviceName;

  const SingleCoreGraph({
    super.key,
    required this.userScore,
    required this.deviceName,
  });
  @override
  Widget build(BuildContext context) {

    final list = buildSingleComparison(userScore, deviceName);

    final maxScore =
        list.map((e) => e.single).reduce((a, b) => a > b ? a : b);
    return Scaffold(
      backgroundColor: CyberTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Single Core Ranking"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final cpu = list[index];
          final bool isUser = cpu.cpu == deviceName;
          final double percent = cpu.single / maxScore;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text("${index + 1}",
                  style: const TextStyle(color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  ),
                SizedBox(
                  width: 160,
                  child: Text(
                    cpu.cpu,
                    style: TextStyle( color: isUser
                          ? CyberTheme.primaryAccent
                          : Colors.white70,
                      fontSize: 13,
                      fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: isUser
                                ? CyberTheme.primaryAccent
                                : Colors.primaries[
                                    index %
                                        Colors.primaries.length],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 60,
                  child: Text(
                    cpu.single.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}