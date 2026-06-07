// ═══════════════════════════════════════════════════════════════════
// 5. lib/widgets/endroits_list.dart
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../modele/endroit.dart';
import '../vue/endroit_detail.dart';

class EndroitsList extends StatelessWidget {
  const EndroitsList({super.key, required this.endroits});

  final List<Endroit> endroits;

  @override
  Widget build(BuildContext context) {
    // Liste vide
    if (endroits.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.place_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucun endroit favori pour le moment.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Appuyez sur + pour en ajouter un.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Liste des endroits
    return ListView.builder(
      itemCount: endroits.length,
      itemBuilder: (context, index) {
        final endroit = endroits[index];
        return ListTile(
          // Vignette de la photo
          leading: CircleAvatar(
            backgroundImage: MemoryImage(endroit.image), // ← MemoryImage
            radius: 26,
          ),
          title: Text(endroit.nom),
          // Adresse si disponible
          subtitle: endroit.adresse != null
              ? Text(
            endroit.adresse!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : null,
          trailing: const Icon(Icons.chevron_right),
          // Navigation vers la page de détails
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EndroitDetail(endroit: endroit),
              ),
            );
          },
        );
      },
    );
  }
}