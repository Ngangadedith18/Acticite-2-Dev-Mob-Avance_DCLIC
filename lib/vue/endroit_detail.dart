// ═══════════════════════════════════════════════════════════════════
// 7. lib/vue/endroit_detail.dart
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modele/endroit.dart';

class EndroitDetail extends StatelessWidget {
  const EndroitDetail({super.key, required this.endroit});

  final Endroit endroit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(endroit.nom)),
      body: Column(
        children: [
          // Photo pleine largeur
          Image.memory( // ← Image.memory
            endroit.image,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),

          // Nom de l'endroit
          Text(
            endroit.nom,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // Adresse si disponible
          if (endroit.adresse != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                endroit.adresse!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],

          // Carte Google Maps si localisation disponible
          if (endroit.aLocalisation) ...[
            const SizedBox(height: 16),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(endroit.latitude!, endroit.longitude!),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('endroit'),
                    position: LatLng(endroit.latitude!, endroit.longitude!),
                    infoWindow: InfoWindow(title: endroit.nom),
                  ),
                },
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}