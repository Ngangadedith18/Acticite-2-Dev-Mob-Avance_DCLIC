// ═══════════════════════════════════════════════════════════════════
// 9. lib/main.dart
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vue/endroits_interface.dart';

void main() {
  runApp(
    // ProviderScope obligatoire pour Riverpod v2
    const ProviderScope(
      child: MonApplication(),
    ),
  );
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endroits Favoris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const EndroitsInterface(),
    );
  }
}