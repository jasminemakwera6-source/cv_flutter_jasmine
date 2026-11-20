import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/donnees.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _lancer(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir ce lien')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <_Item>[
      _Item(
        Icons.phone,
        'Appeler',
        Donnees.telephone,
        Colors.green,
        Uri(scheme: 'tel', path: Donnees.telephone),
      ),
      _Item(
        Icons.mail,
        'E-mail',
        Donnees.email,
        Colors.redAccent,
        Uri(scheme: 'mailto', path: Donnees.email),
      ),
      _Item(Icons.place, 'Adresse', Donnees.adresse, Colors.orange, null),
      _Item(
        Icons.work,
        'LinkedIn',
        Donnees.linkedin,
        Colors.blue,
        Uri.parse(Donnees.linkedin),
      ),
      _Item(
        Icons.terminal,
        'GitHub',
        Donnees.github,
        Colors.purpleAccent,
        Uri.parse(Donnees.github),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final it = items[i];
        return Material(
          color: const Color(0xFF1A232C),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: it.uri == null ? null : () => _lancer(context, it.uri!),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: it.couleur.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(it.icone, color: it.couleur),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it.titre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          it.valeur,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  if (it.uri != null)
                    const Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Item {
  final IconData icone;
  final String titre;
  final String valeur;
  final Color couleur;
  final Uri? uri;
  const _Item(this.icone, this.titre, this.valeur, this.couleur, this.uri);
}
