import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  final String title;
  const InfoHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00E5FF), // Sir's Light Blue
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 2.0, // More spacing for tech feel
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const Color lightBlueAccent = Color(0xFF00E5FF);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0D3A), // Midnight Blue Card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)), // Subtle border
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        title: Text(
          label.toUpperCase(), // All caps labels for consistency
          style: const TextStyle(
            color: lightBlueAccent, // Labels are now Light Blue
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        trailing: Container(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white, // Data values are Pure White
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}