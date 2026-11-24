import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/ApiExeption.dart';
import 'package:flutter_cvjasmine/http.dart';
import 'package:flutter_cvjasmine/theme.dart';

/// Formulaire d'ajout (membre == null) ou de modification d'un membre.
class FormulaireMembrePage extends StatefulWidget {
  final FamilleMembre? membre;
  const FormulaireMembrePage({super.key, this.membre});

  @override
  State<FormulaireMembrePage> createState() => _FormulaireMembrePageState();
}

class _FormulaireMembrePageState extends State<FormulaireMembrePage> {
  final _cle = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _postnom = TextEditingController();
  final _prenom = TextEditingController();
  final _lieu = TextEditingController();
  final _parente = TextEditingController();
  final _image = TextEditingController();
  DateTime? _date;
  bool _chargement = false;

  bool get _modification => widget.membre != null;

  @override
  void initState() {
    super.initState();
    final m = widget.membre;
    if (m != null) {
      _nom.text = m.nom;
      _postnom.text = m.postnom;
      _prenom.text = m.prenom;
      _lieu.text = m.lieuNaissance;
      _parente.text = m.parente;
      _image.text = m.image ?? '';
      _date = DateTime.tryParse(m.dateNaissance);
    }
  }

  @override
  void dispose() {
    _nom.dispose();
    _postnom.dispose();
    _prenom.dispose();
    _lieu.dispose();
    _parente.dispose();
    _image.dispose();
    super.dispose();
  }

  // 1990-03-05 : format attendu par l'API
  String _formater(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        _date = d;
      });
    }
  }

  Future<void> _enregistrer() async {
    if (!_cle.currentState!.validate()) return;
    if (_date == null) {
      afficherMessage(context, 'Choisissez la date de naissance');
      return;
    }

    final image = _image.text.trim().isEmpty ? null : _image.text.trim();

    setState(() {
      _chargement = true;
    });
    try {
      if (_modification) {
        await ApiService.modifierMembre(
          widget.membre!.id,
          nom: _nom.text.trim(),
          postnom: _postnom.text.trim(),
          prenom: _prenom.text.trim(),
          lieuNaissance: _lieu.text.trim(),
          dateNaissance: _formater(_date!),
          parente: _parente.text.trim(),
          image: image,
        );
      } else {
        await ApiService.ajouterMembre(
          nom: _nom.text.trim(),
          postnom: _postnom.text.trim(),
          prenom: _prenom.text.trim(),
          lieuNaissance: _lieu.text.trim(),
          dateNaissance: _formater(_date!),
          parente: _parente.text.trim(),
          image: image,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true); // true = recharger la liste
    } on ApiException catch (e) {
      if (!mounted) return;
      afficherMessage(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _chargement = false;
        });
      }
    }
  }

  Widget _champ(
    TextEditingController c,
    String label,
    IconData icone, {
    bool obligatoire = true,
    String? aide,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: obligatoire ? label : '$label (facultatif)',
          helperText: aide,
          prefixIcon: Icon(icone),
        ),
        validator: obligatoire
            ? (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modification ? 'Modifier le membre' : 'Ajouter un membre'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _cle,
              child: Column(
                children: [
                  _champ(_nom, 'Nom', Icons.person),
                  _champ(_postnom, 'Postnom', Icons.person_outline),
                  _champ(_prenom, 'Prénom', Icons.badge_outlined),
                  _champ(
                    _lieu,
                    'Lieu de naissance',
                    Icons.location_on_outlined,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: _choisirDate,
                      borderRadius: BorderRadius.circular(16),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date de naissance',
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        child: Text(
                          _date == null
                              ? 'Appuyez pour choisir'
                              : _formater(_date!),
                        ),
                      ),
                    ),
                  ),
                  _champ(
                    _parente,
                    'Lien de parenté (père, mère, frère…)',
                    Icons.family_restroom,
                  ),
                  _champ(
                    _image,
                    'Photo',
                    Icons.image_outlined,
                    obligatoire: false,
                    aide: 'Ex. assets/images/pere.jpg ou https://…',
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _chargement ? null : _enregistrer,
                      style: FilledButton.styleFrom(
                        backgroundColor: turquoise,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _chargement
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              _modification
                                  ? 'Enregistrer les changements'
                                  : 'Enregistrer',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
