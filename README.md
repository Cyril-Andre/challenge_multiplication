
# Challenge Multiplication

## 🌟 Description
**Challenge Multiplication** est une application mobile Flutter conçue pour aider les enfants à apprendre et maîtriser leurs tables de multiplication. Le joueur doit répondre à **20 multiplications aléatoires (tables de 3 à 9)** en moins d'une minute. Les scores sont sauvegardés pour suivre la progression avec des graphiques clairs et motivants.

## 📱 Disponible sur :
- **Google Play Store**
- **Apple App Store**

## 🏷 Version actuelle
**v1.0.0** - Première release officielle publiée sur les stores.

---

## 📚 Architecture

L'application suit une architecture **Clean Architecture (en oignon)** avec le design pattern **MVVM (Model-View-ViewModel)**. Chaque fonctionnalité est isolée dans son propre répertoire.


```plaintext
challenge_multiplication/
├── .fvmrc
├── .gitignore
├── pubspec.yaml
├── README.md
├── assets/
│   └── config/
│       ├── .env.local
│       └── .env.prod
├── lib/
│   ├── challenge_multiplication_app.dart
│   ├── common_main.dart
│   ├── main.dart
│   ├── main_local.dart
│   ├── main_prod.dart
│   ├── theme/
│   │   └── theme.dart
│   ├── common/
│   │   ├── globals.dart
│   │   ├── services/
│   │   │   ├── router.dart
│   │   │   └── storage_service.dart
│   │   └── widgets/
│   │       └── app_scaffold.dart
│   ├── features/
│   │   ├── home/
│   │   │   └── views/
│   │   │       └── home_screen.dart
│   │   ├── players/
│   │   │   ├── models/
│   │   │   │   └── player.dart
│   │   │   ├── services/
│   │   │   │   └── player_service.dart
│   │   │   ├── viewmodels/
│   │   │   │   ├── player_auth_view_model.dart
│   │   │   │   ├── player_selection_view_model.dart
│   │   │   │   └── registration_vew_model.dart
│   │   │   ├── views/
│   │   │   │   ├── player_auth_screen.dart
│   │   │   │   ├── player_register_screen.dart
│   │   │   │   └── player_selection_screen.dart
│   │   │   └── widgets/
│   │   │       └── player_card.dart
│   │   ├── game/
│   │   │   ├── models/
│   │   │   │   └── multiplication.dart
│   │   │   ├── viewmodels/
│   │   │   │   ├── game_play_screen_viewmodel.dart
│   │   │   │   └── game_viewmodel.dart
│   │   │   └── views/
│   │   │       ├── game_play_screen.dart
│   │   │       ├── game_result_screen.dart
│   │   │       └── game_screen.dart
│   │   ├── history/
│   │   │   ├── models/
│   │   │   │   └── history_entry.dart
│   │   │   ├── viewmodels/
│   │   │   │   └── history_viewmodel.dart
│   │   │   ├── views/
│   │   │   │   └── history_screen.dart
│   │   │   └── widget/
│   │   │       └── score_card.dart
```

---

## 🛠 Fonctionnalités

- ✨ **Multiplications aléatoires** sur les tables de 3 à 9
- ⏳ **Chronomètre d'1 minute** pour répondre aux 20 questions
- 🏆 **Sauvegarde des scores** localement avec `shared_preferences`
- 📊 **Graphiques** pour visualiser les performances (via `fl_chart`)
- 👤 **Multi-profils joueurs** (création et sélection du joueur)
- 🔐 **Authentification locale** simple pour chaque joueur
- 💾 **Historique des résultats** consultable

---

## 🔮 Fonctionnalités prévues
- 🎯 Mode Entraînement libre sans limite de temps
- 📈 Statistiques détaillées par table de multiplication
- 🌍 Mode multilingue (anglais, français, néerlandais…)

---

## 🌟 Technologies Utilisées
- **Flutter** (géré via **FVM**)
- **Provider** pour la gestion d'état
- **Shared Preferences** pour le stockage local
- **FL Chart** pour l'affichage des scores

---

## 🚀 Développement et Contribution

1. **Clone le projet :**
   \`\`\`sh
   git clone https://github.com/ton-user/challenge_multiplication.git
   cd challenge_multiplication
   \`\`\`

2. **Crée une branche :**
   \`\`\`sh
   git checkout -b feature/nouvelle-fonctionnalite
   \`\`\`

3. **Développe, teste et commit :**
   \`\`\`sh
   git commit -m "Ajout d'une nouvelle fonctionnalité"
   git push origin feature/nouvelle-fonctionnalite
   \`\`\`

4. **Ouvre une Pull Request !**

---

## 👨‍💻 Auteur
**Cyril ANDRE - Lilarisz**  
Développeur Flutter & Passionné par l’apprentissage ludique

---

## 📜 Licence
Ce projet est sous licence **MIT**. Voir [LICENSE](https://opensource.org/licenses/MIT) pour plus de détails.
