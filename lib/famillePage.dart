import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/ApiExeption.dart';
import 'package:flutter_cvjasmine/FormulaireMembre.dart';
import 'package:flutter_cvjasmine/http.dart';
import 'package:flutter_cvjasmine/photos.dart';
import 'package:flutter_cvjasmine/theme.dart';

/// Liste de la famille en grille, avec ajout, modification et suppression.
class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  late Future<List<FamilleMembre>> _futur = ApiService.famille();

  Future<void> _recharger() async {
    setState(() {
      _futur = ApiService.famille();
    });
    await _futur.catchError((_) => <FamilleMembre>[]);
  }

  // Ajout (membre == null) ou modification
  Future<void> _ouvrirFormulaire({FamilleMembre? membre}) async {
    final change = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => FormulaireMembrePage(membre: membre)),
    );
    if (change == true && mounted) {
      afficherMessage(
        context,
        membre == null ? 'Membre ajouté' : 'Membre modifié',
      );
      _recharger();
    }
  }

  // Confirmation, puis suppression
  Future<void> _supprimer(FamilleMembre m) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('Voulez-vous vraiment supprimer ${m.nomComplet} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true) return;

    try {
      await ApiService.supprimerMembre(m.id);
      if (!mounted) return;
      afficherMessage(context, 'Membre supprimé');
      _recharger();
    } on ApiException catch (e) {
      if (!mounted) return;
      afficherMessage(context, e.message);
    }
  }

  Widget _carte(FamilleMembre m) {
    return Material(
      color: carte,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _ouvrirFormulaire(membre: m), // appui = modifier
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        tooltip: 'Actions',
                        onSelected: (choix) {
                          if (choix == 'modifier') _ouvrirFormulaire(membre: m);
                          if (choix == 'supprimer') _supprimer(m);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'modifier',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Modifier'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'supprimer',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Supprimer'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.nomComplet,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: ambre.withAlpha(50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m.parente,
                      style: const TextStyle(color: ambre, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Né(e) le ${m.dateNaissance}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        backgroundColor: turquoise,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
      body: FutureBuilder<List<FamilleMembre>>(
        future: _futur,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snap.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _recharger,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final membres = snap.data!;
          return RefreshIndicator(
            onRefresh: _recharger,
            child: membres.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Text('Aucun membre. Appuyez sur « Ajouter ».'),
                      ),
                    ],
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    // espace en bas pour que le bouton ne cache pas une carte
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 230,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: membres.length,
                    itemBuilder: (context, i) => _carte(membres[i]),
                  ),
          );
        },
      ),
    );
  }
}
