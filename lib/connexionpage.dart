import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/coques.dart';
import 'package:flutter_cvjasmine/donnees.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _cle = GlobalKey<FormState>();
  final _login = TextEditingController();
  final _mdp = TextEditingController();
  bool _cache = true;

  @override
  void dispose() {
    _login.dispose();
    _mdp.dispose();
    super.dispose();
  }

  void _valider() {
    if (!_cle.currentState!.validate()) return;
    if (_login.text.trim() == Donnees.login &&
        _mdp.text == Donnees.motDePasse) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const Coque()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identifiant ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c.primary.withOpacity(0.35), const Color(0xFF10161C)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A232C),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: c.primary.withOpacity(0.4)),
                ),
                child: Form(
                  key: _cle,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: c.primary.withOpacity(0.2),
                        child: Icon(
                          Icons.lock_outline,
                          size: 34,
                          color: c.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connexion',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Accédez à mon portfolio',
                        style: TextStyle(color: c.secondary),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _login,
                        textInputAction: TextInputAction.next,
                        decoration: _deco('Identifiant', Icons.alternate_email),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Identifiant requis'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mdp,
                        obscureText: _cache,
                        onFieldSubmitted: (_) => _valider(),
                        decoration: _deco('Mot de passe', Icons.key).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _cache ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () => setState(() => _cache = !_cache),
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
                        child: ElevatedButton(
                          onPressed: _valider,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Se connecter',
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
        ),
      ),
    );
  }

  InputDecoration _deco(String label, IconData icone) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icone),
    filled: true,
    fillColor: const Color(0xFF10161C),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );
}
