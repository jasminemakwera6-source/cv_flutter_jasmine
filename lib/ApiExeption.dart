import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class Etudiant {
  final String nom;
  final String postnom;
  final String prenom;
  final String adresse;
  final String telephone;

  Etudiant({
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
  });

  factory Etudiant.fromJson(Map<String, dynamic> j) => Etudiant(
    nom: '${j['nom'] ?? ''}',
    postnom: '${j['postnom'] ?? ''}',
    prenom: '${j['prenom'] ?? ''}',
    adresse: '${j['adresse'] ?? ''}',
    telephone: '${j['telephone'] ?? ''}',
  );

  String get nomComplet => '$prenom $nom $postnom'.trim();
}

class FamilleMembre {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // AAAA-MM-JJ
  final String? image;
  final String parente;

  FamilleMembre({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.image,
    required this.parente,
  });

  factory FamilleMembre.fromJson(Map<String, dynamic> j) {
    final date = '${j['date_naissance'] ?? ''}';
    return FamilleMembre(
      id: int.tryParse('${j['id']}') ?? 0,
      nom: '${j['nom'] ?? ''}',
      postnom: '${j['postnom'] ?? ''}',
      prenom: '${j['prenom'] ?? ''}',
      lieuNaissance: '${j['lieu_naissance'] ?? ''}',
      dateNaissance: date.length >= 10 ? date.substring(0, 10) : date,
      image: j['image'] == null ? null : '${j['image']}',
      parente: '${j['parente'] ?? ''}',
    );
  }

  String get nomComplet => '$prenom $nom $postnom'.trim();
}

class ApiService {
  // Windows : localhost | émulateur Android : 10.0.2.2 | vrai téléphone : IP du PC
  static const String baseUrl = 'http://localhost:8080';

  static const _entetes = {'Content-Type': 'application/json'};
  static const _delai = Duration(seconds: 10);

  static Map<String, dynamic> _lire(http.Response r) {
    try {
      final d = jsonDecode(utf8.decode(r.bodyBytes));
      if (d is Map<String, dynamic>) return d;
      return {'data': d};
    } catch (_) {
      throw ApiException('Réponse invalide du serveur (${r.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> _appel(
    Future<http.Response> Function() requete,
    String messageParDefaut,
  ) async {
    try {
      final r = await requete().timeout(_delai);
      final d = _lire(r);
      if (r.statusCode >= 400 || d['success'] == false) {
        throw ApiException('${d['message'] ?? messageParDefaut}');
      }
      return d;
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('ERREUR RÉSEAU : $e');
      throw ApiException(
        'Serveur injoignable. Vérifiez l\'adresse ($baseUrl).',
      );
    }
  }

  // ---------- Comptes ----------
  static Future<void> login(String email, String motDePasse) async {
    await _appel(
      () => http.post(
        Uri.parse('$baseUrl/accounts/login'),
        headers: _entetes,
        body: jsonEncode({'email': email, 'password': motDePasse}),
      ),
      'Connexion refusée',
    );
  }

  static Future<void> register(String email, String motDePasse) async {
    await _appel(
      () => http.post(
        Uri.parse('$baseUrl/accounts/register'),
        headers: _entetes,
        body: jsonEncode({'email': email, 'password': motDePasse}),
      ),
      'Inscription refusée',
    );
  }

  // ---------- Étudiant ----------
  static Future<Etudiant?> etudiant() async {
    try {
      final d = await _appel(
        () => http.get(Uri.parse('$baseUrl/etudiants'), headers: _entetes),
        'Erreur serveur',
      );
      final liste = d['data'] ?? d['etudiants'] ?? [];
      if (liste is List && liste.isNotEmpty) {
        return Etudiant.fromJson(Map<String, dynamic>.from(liste.first as Map));
      }
    } on ApiException {
      return null;
    }
    return null;
  }

  // ---------- Famille ----------
  static Future<List<FamilleMembre>> famille() async {
    final d = await _appel(
      () => http.get(Uri.parse('$baseUrl/famille-membres'), headers: _entetes),
      'Impossible de charger la famille',
    );
    final liste = d['data'] ?? d['membres'] ?? [];
    if (liste is! List) throw ApiException('Réponse inattendue du serveur');
    return liste
        .map((e) => FamilleMembre.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Map<String, dynamic> _corps({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    String? image,
  }) => {
    'nom': nom,
    'postnom': postnom,
    'prenom': prenom,
    'lieu_naissance': lieuNaissance,
    'date_naissance': dateNaissance,
    'parente': parente,
    'image': image,
  };

  static Future<void> ajouterMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    String? image,
  }) async {
    await _appel(
      () => http.post(
        Uri.parse('$baseUrl/famille-membres'),
        headers: _entetes,
        body: jsonEncode(
          _corps(
            nom: nom,
            postnom: postnom,
            prenom: prenom,
            lieuNaissance: lieuNaissance,
            dateNaissance: dateNaissance,
            parente: parente,
            image: image,
          ),
        ),
      ),
      'Ajout refusé',
    );
  }

  static Future<void> modifierMembre(
    int id, {
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    String? image,
  }) async {
    await _appel(
      () => http.put(
        Uri.parse('$baseUrl/famille-membres/$id'),
        headers: _entetes,
        body: jsonEncode(
          _corps(
            nom: nom,
            postnom: postnom,
            prenom: prenom,
            lieuNaissance: lieuNaissance,
            dateNaissance: dateNaissance,
            parente: parente,
            image: image,
          ),
        ),
      ),
      'Modification refusée',
    );
  }

  static Future<void> supprimerMembre(int id) async {
    await _appel(
      () => http.delete(
        Uri.parse('$baseUrl/famille-membres/$id'),
        headers: _entetes,
      ),
      'Suppression refusée',
    );
  }
}
