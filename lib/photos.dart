import 'package:flutter/material.dart';

/// Photo avec icône de secours si l'image est introuvable.
class Photo extends StatelessWidget {
  final String asset;
  final double? largeur;
  final double? hauteur;
  final BoxFit fit;
  const Photo({
    super.key,
    required this.asset,
    this.largeur,
    this.hauteur,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SizedBox(
      width: largeur,
      height: hauteur,
      child: Image.asset(
        asset,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          color: c.surfaceContainerHighest,
          child: Icon(Icons.person, size: 48, color: c.primary),
        ),
      ),
    );
  }
}
