// ═══════════════════════════════════════════════════════════════════
// 8. lib/vue/endroits_interface.dart
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/endroits_list.dart';
import 'ajout_endroit.dart';

// ConsumerWidget suffit : pas d'état local, uniquement lecture du provider
class EndroitsInterface extends ConsumerWidget {
  const EndroitsInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute les changements du provider — reconstruction automatique
    final endroits = ref.watch(endroitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes endroits préférés'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AjoutEndroit(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: EndroitsList(endroits: endroits),
      ),
    );
  }
} 