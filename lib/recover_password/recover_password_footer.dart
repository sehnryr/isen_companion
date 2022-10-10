import 'package:flutter/material.dart';

import 'package:isen_companion/base/base_footer.dart';

class RecoverPasswordFooter extends BaseFooter {
  const RecoverPasswordFooter({Key? key})
      : super(
          "¹: Ce code est inscrit sur votre carte d'étudiant à coté de N° Etudiant, première ligne à gauche sous le code-barres, ou bien sur votre passeport infomatique.",
          key: key,
        );
}
