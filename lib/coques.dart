import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/AcceuilPage.dart';
import 'package:flutter_cvjasmine/connexionpage.dart';
import 'package:flutter_cvjasmine/contactPage.dart';
import 'package:flutter_cvjasmine/donnees.dart';
import 'package:flutter_cvjasmine/famillePage.dart';
import 'package:flutter_cvjasmine/photos.dart';

/// Écran principal avec menu latéral (Drawer).
class Coque extends StatefulWidget {
  const Coque({super.key});

  @override
  State<Coque> createState() => _CoqueState();
}

class _CoqueState extends State<Coque> {
  int _page = 0;

  static const _titres = ['Mon CV', 'Ma famille', 'Me contacter'];
  static const _icones = [Icons.badge, Icons.groups, Icons.alternate_email];
  static const _contenus = [AccueilPage(), FamillePage()];

  void _aller(int i) {
    setState(() => _page = i);
    Navigator.pop(context); // ferme le Drawer
  }

  void _deconnexion() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const ConnexionPage()));
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(_titres[_page])),
      drawer: Drawer(
        backgroundColor: const Color(0xFF151D25),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [c.primary.withOpacity(0.5), const Color(0xFF151D25)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Photo(
                      asset: Donnees.photo,
                      largeur: 72,
                      hauteur: 72,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    Donnees.nom,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(Donnees.profil, style: TextStyle(color: c.secondary)),
                ],
              ),
            ),
            for (var i = 0; i < _titres.length; i++)
              ListTile(
                leading: Icon(_icones[i]),
                title: Text(_titres[i]),
                selected: i == _page,
                selectedTileColor: c.primary.withOpacity(0.15),
                onTap: () => _aller(i),
              ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: _deconnexion,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: _contenus[_page],
    );
  }
}
