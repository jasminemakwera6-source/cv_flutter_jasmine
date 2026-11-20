import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/donnees.dart';
import 'package:flutter_cvjasmine/photos.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // En-tête
        Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary.withOpacity(0.45), const Color(0xFF10161C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.secondary, width: 3),
                ),
                child: ClipOval(
                  child: const Photo(
                    asset: Donnees.photo,
                    largeur: 120,
                    hauteur: 120,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                Donnees.nom,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                Donnees.profil,
                style: TextStyle(color: c.secondary, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                Donnees.apropos,
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.4),
              ),
            ],
          ),
        ),

        _Titre(icone: Icons.school, texte: 'Formation'),
        _Frise(etapes: Donnees.formations),

        _Titre(icone: Icons.work_outline, texte: 'Expériences'),
        _Frise(etapes: Donnees.experiences),

        _Titre(icone: Icons.code, texte: 'Compétences techniques'),
        _Barres(valeurs: Donnees.competences),

        _Titre(icone: Icons.translate, texte: 'Langues'),
        _Barres(valeurs: Donnees.langues),

        _Titre(icone: Icons.interests, texte: 'Centres d\'intérêt'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final i in Donnees.interets)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: c.secondary),
                  ),
                  child: Text(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Titre extends StatelessWidget {
  final IconData icone;
  final String texte;
  const _Titre({required this.icone, required this.texte});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Icon(icone, color: c.primary),
          const SizedBox(width: 10),
          Text(
            texte,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Frise chronologique : point + ligne verticale + contenu.
class _Frise extends StatelessWidget {
  final List<Etape> etapes;
  const _Frise({required this.etapes});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var i = 0; i < etapes.length; i++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: c.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (i < etapes.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: c.primary.withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            etapes[i].periode,
                            style: TextStyle(
                              color: c.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            etapes[i].titre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            etapes[i].lieu,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            etapes[i].detail,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Barres de progression pour compétences et langues.
class _Barres extends StatelessWidget {
  final Map<String, double> valeurs;
  const _Barres({required this.valeurs});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (final e in valeurs.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.key),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: e.value,
                      minHeight: 8,
                      color: c.primary,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
