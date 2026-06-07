// ═══════════════════════════════════════════════════════════════════
// 4. lib/widgets/localisation_prise.dart
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalisationPrise extends StatefulWidget {
  const LocalisationPrise({
    super.key,
    required this.onLocalisationSelectionnee,
  });

  final void Function(double lat, double lng, String adresse)
      onLocalisationSelectionnee;

  @override
  State<LocalisationPrise> createState() => _LocalisationPriseState();
}

class _LocalisationPriseState extends State<LocalisationPrise> {
  double? _latitude;
  double? _longitude;
  String? _adresse;
  bool _chargement = false;

  Future<void> _obtenirLocalisation() async {
    if (!mounted) return;
    setState(() => _chargement = true);

    // Vérifier et demander les permissions GPS
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      setState(() => _chargement = false);
      return;
    }

    try {
      // Timeout 10 secondes pour éviter de tourner indéfiniment
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 30),
        ),
      );

      _latitude  = position.latitude;
      _longitude = position.longitude;

      // Convertir les coordonnées en adresse lisible
      try {
        final placemarks = await placemarkFromCoordinates(
          _latitude!,
          _longitude!,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _adresse = '${place.street}, ${place.locality}, ${place.country}';
        } else {
          _adresse =
              '${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}';
        }
      } catch (_) {
        // Geocoding échoué — afficher les coordonnées brutes
        _adresse =
            '${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}';
      }

      // Transmettre la localisation au parent
      widget.onLocalisationSelectionnee(_latitude!, _longitude!, _adresse!);

    } catch (e) {
      // Timeout ou GPS indisponible — position par défaut de l'émulateur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'obtenir la position GPS.')),
        );
      }
    } finally {
      setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Chargement en cours
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }

    // Localisation obtenue : mini-carte + adresse
    if (_latitude != null && _longitude != null) {
      return Column(
        children: [
          SizedBox(
            height: 150,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude!, _longitude!),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('endroit'),
                  position: LatLng(_latitude!, _longitude!),
                ),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _adresse ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    // Pas encore de localisation : bouton
    return TextButton.icon(
      onPressed: _obtenirLocalisation,
      icon: const Icon(Icons.location_on),
      label: const Text('Obtenir ma localisation'),
    );
  }
}