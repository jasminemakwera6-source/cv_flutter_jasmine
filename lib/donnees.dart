class Etape {
  final String titre;
  final String lieu;
  final String periode;
  final String detail;
  const Etape(this.titre, this.lieu, this.periode, this.detail);
}

class Proche {
  final String nom;
  final String lien;
  final String metier;
  final String photo;
  const Proche(this.nom, this.lien, this.metier, this.photo);
}

class Donnees {
  static const login = 'admin';
  static const motDePasse = '1234';

  static const nom = 'JASMINE MAKWERA';
  static const profil = 'Administrateur réseau';
  static const photo = 'assets/images/moi.jpg';
  static const apropos =
      'Passionné par l\'administrateur réseau et utiles. '
      'Curieuse, rigoureuse et toujours prêt à apprendre.';

  static const formations = [
    Etape(
      'Licence en Informatique',
      'ISIG-GOMA',
      '2024 – 2025',
      'Programmation, bases de données, réseaux.',
    ),
    Etape('Baccalauréat', 'Ujumbe', '2023 – 2024', 'Pedagogie.'),
  ];

  static const experiences = [
    Etape(
      'Stage d\'aministrateur réseau',
      'l\'entreprise',
      'Été 2026',
      'Développement d\'un module de gestion interne.',
    ),
    Etape(
      'Projet universitaire',
      'Université',
      '2025',
      'Application de gestion réalisée en équipe de 4.',
    ),
    Etape('Etudiant', 'Jasmine', '2024', 'Support informatique et accueil.'),
  ];

  // nom de la compétence -> niveau de 0 à 1
  static const competences = {
    'Data analyste': 0.8,
    'Git & GitHub': 0.7,
    'HTML / CSS': 0.7,
    'Design,': 0.6,
    'administrateur réseau': 0.6,
  };

  static const langues = {'Français': 1.0, 'Anglais': 0.6, 'Swahili': 0.9};

  static const interets = ['Programmation', 'Lecture', 'Musique', 'Voyages'];

  static const famille = [
    Proche('John makwera', 'Père', 'Profession', 'assets/images/pere.jpg'),
    Proche('Élodie kabeho', 'Mère', 'Profession', 'assets/images/mere.jpg'),
    Proche('Jemima makwera', 'Sœur', 'Eleve', 'assets/images/soeurtte.jpg'),
    Proche('jovial makwera', 'Sœur', 'Éleve', 'assets/images/soeur.jpg'),
  ];

  static const telephone = '+243980153775';
  static const email = 'jasminemakwera6@gmail.com';
  static const adresse = 'Goma, RDC';
  static const linkedin = 'https://www.linkedin.com/in/profil';
  static const github =
      'https://github.com/jasminemakwera6-source/cv_flutter_jasmine.git';
}
