// ═══════════════════════════════════════════════════════════════════
// 1. lib/modele/endroit.dart
// ═══════════════════════════════════════════════════════════════════
//import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

// Constante globale — génère des UUID uniques
const uuid = Uuid();

class Endroit {
  // Constructeur : id généré automatiquement via uuid.v4()
  Endroit({
    required this.nom,
    required this.image,
    this.latitude,
    this.longitude,
    this.adresse,
  }) : id = uuid.v4();

  final String id;        // identifiant unique
  final String nom;       // nom de l'endroit
  //final File image;       // photo prise avec la caméra
  final Uint8List image;
  final double? latitude; // coordonnées GPS (optionnelles)
  final double? longitude;
  final String? adresse;  // adresse lisible (ex: "Paris, France")

  // Retourne true si une localisation GPS est disponible
  bool get aLocalisation => latitude != null && longitude != null;
}