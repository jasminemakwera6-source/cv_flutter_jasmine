import 'package:flutter/material.dart';

void afficherMessage(BuildContext context, String texte) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));
}
