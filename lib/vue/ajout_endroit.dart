// ═══════════════════════════════════════════════════════════════════
// 6. lib/vue/ajout_endroit.dart
// ═══════════════════════════════════════════════════════════════════
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/image_prise.dart';
import '../widgets/localisation_prise.dart';

// ConsumerStatefulWidget : état local + accès aux providers Riverpod
class AjoutEndroit extends ConsumerStatefulWidget {
  const AjoutEndroit({super.key});

  @override
  ConsumerState<AjoutEndroit> createState() => _AjoutEndroitState();
}

class _AjoutEndroitState extends ConsumerState<AjoutEndroit> {
  final _nomController = TextEditingController();
  Uint8List? _imageSelectionnee;
  double? _latitude;
  double? _longitude;
  String? _adresse;

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  // Callback reçu depuis ImagePrise
  void _surPhotoSelectionnee(Uint8List image) { // ← Uint8List, pas File
    setState(() => _imageSelectionnee = image);  // ← assignation directe
  }

  // Callback reçu depuis LocalisationPrise
  void _surLocalisationSelectionnee(
      double lat, double lng, String adresse) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _adresse = adresse;
    });
  }

  // Validation et enregistrement de l'endroit
  void _enregistrerEndroit() {
    final nom = _nomController.text.trim();

    if (nom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un nom.')),
      );
      return;
    }

    if (_imageSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez prendre une photo.')),
      );
      return;
    }

    ref.read(endroitsProvider.notifier).ajouterEndroit(
      nom: nom,
      image: _imageSelectionnee!,
      latitude: _latitude,
      longitude: _longitude,
      adresse: _adresse,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajout d'un nouvel endroit")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: "Nom de l'endroit",
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            const Text(
              'Photo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ImagePrise(onPhotoSelectionnee: _surPhotoSelectionnee),
            const SizedBox(height: 16),
            const Text(
              'Localisation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LocalisationPrise(
              onLocalisationSelectionnee: _surLocalisationSelectionnee,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _enregistrerEndroit,
              icon: const Icon(Icons.save),
              label: const Text("Enregistrer l'endroit"),
            ),
          ],
        ),
      ),
    );
  }
}