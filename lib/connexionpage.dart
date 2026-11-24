import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/ApiExeption.dart';
import 'package:flutter_cvjasmine/Inscritpion.dart';
import 'package:flutter_cvjasmine/coques.dart';
import 'package:flutter_cvjasmine/http.dart';
import 'package:flutter_cvjasmine/theme.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _cle = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _mdp = TextEditingController();
  bool _cache = true;
  bool _chargement = false;

  @override
  void dispose() {
    _email.dispose();
    _mdp.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    if (!_cle.currentState!.validate()) return;
    setState(() {
      _chargement = true;
    });
    try {
      await ApiService.login(_email.text.trim(), _mdp.text);
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const Coque()));
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [turquoise.withAlpha(90), fond],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: carte,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: turquoise.withAlpha(100)),
                  ),
                  child: Form(
                    key: _cle,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: turquoise.withAlpha(50),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 34,
                            color: turquoise,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Accédez à mon portfolio',
                          style: TextStyle(color: ambre),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Identifiant (e-mail)',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Identifiant requis'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mdp,
                          obscureText: _cache,
                          onFieldSubmitted: (_) => _valider(),
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _cache
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cache = !_cache;
                                });
                              },
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Mot de passe requis'
                              : null,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _chargement ? null : _valider,
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
                                    'Se connecter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const InscriptionPage(),
                              ),
                            );
                          },
                          child: const Text('Créer un compte'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
