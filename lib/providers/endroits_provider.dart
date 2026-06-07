// ═══════════════════════════════════════════════════════════════════
// 2. lib/providers/endroits_provider.dart
// ═══════════════════════════════════════════════════════════════════
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modele/endroit.dart';

// Riverpod v2 : Notifier remplace StateNotifier
class EndroitsNotifier extends Notifier<List<Endroit>> {

  // build() remplace le constructeur — définit l'état initial
  @override
  List<Endroit> build() => [];

  // Ajouter un endroit en tête de liste
  void ajouterEndroit({
    required String nom,
    required Uint8List image,
    double? latitude,
    double? longitude,
    String? adresse,
  }) {
    final nouvelEndroit = Endroit(
      nom: nom,
      image: image,
      latitude: latitude,
      longitude: longitude,
      adresse: adresse,
    );
    state = [nouvelEndroit, ...state];
  }

  // Supprimer un endroit par son id
  void supprimerEndroit(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

// Riverpod v2 : NotifierProvider remplace StateNotifierProvider
final endroitsProvider = NotifierProvider<EndroitsNotifier, List<Endroit>>(
  EndroitsNotifier.new,
);