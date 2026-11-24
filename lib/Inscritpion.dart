import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/ApiExeption.dart';
import 'package:flutter_cvjasmine/http.dart';
import 'package:flutter_cvjasmine/theme.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _cle = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _mdp = TextEditingController();
  final _confirmation = TextEditingController();
  bool _chargement = false;

  @override
  void dispose() {
    _email.dispose();
    _mdp.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _creer() async {
    if (!_cle.currentState!.validate()) return;
    setState(() {
      _chargement = true;
    });
    try {
      await ApiService.register(_email.text.trim(), _mdp.text);
      if (!mounted) return;
      afficherMessage(context, 'Compte créé, connectez-vous');
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _cle,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'E-mail invalide'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mdp,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (v) => (v == null || v.length < 4)
                        ? '4 caractères minimum'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmation,
                    obscureText: true,
                    onFieldSubmitted: (_) => _creer(),
                    decoration: const InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      prefixIcon: Icon(Icons.key_outlined),
                    ),
                    validator: (v) =>
                        v != _mdp.text ? 'Les mots de passe diffèrent' : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _chargement ? null : _creer,
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
                          : const Text(
                              'Créer le compte',
                              style: TextStyle(
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
