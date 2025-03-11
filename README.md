# Challenge Multiplication

## 🌟 Description
Challenge Multiplication est une application mobile Flutter conçue pour aider les enfants à apprendre et maîtriser leurs tables de multiplication. Le jeu propose un challenge où le joueur doit répondre à 20 multiplications aléatoires (des tables de 3 à 9) en moins d'une minute. Les scores sont enregistrés pour suivre la progression du joueur à l'aide de graphiques.

## 📚 Architecture
L'application est organisée selon une architecture en oignon (Clean Architecture) avec MVVM (Model-View-ViewModel), en isolant chaque feature dans son propre répertoire :
```
challenge_multiplication/
├── .fvmrc
├── .gitignore
├── pubspec.yaml
├── README.md
├── assets/
│   ├── config/.env.local
│   ├── config/.env.prod
├── lib/
│   ├── common/
│   │   ├── services/
│   │   │   ├── router.dart
│   │   ├── widgets/
│   │   │   ├── app_scaffold.dart
│   │   ├── theme.dart
│   ├── features/
│   │   ├── game/
│   │   │   ├── models/
│   │   │   │   ├── multiplication.dart
│   │   │   ├── viewmodels/
│   │   │   │   ├── game_viewmodel.dart
│   │   │   │   ├── game_play_screen_viewmodel.dart
│   │   │   ├── views/
│   │   │   │   ├── game_screen.dart
│   │   │   │   ├── game_play_screen.dart
│   │   │   │   ├── game_result_screen.dart
│   │   ├── home/
│   │   │   ├── models/
│   │   │   ├── viewmodels/
│   │   │   ├── views/
│   │   │   │   ├── home_screen.dart
│   │   ├── history/
│   │   ├── settings/
│   ├── theme/
│   │   ├── theme.dart
│   ├── challenge_multiplication.dart
│   ├── common_main.dart
│   ├── main_local.dart
│   ├── main_prod.dart
│   ├── main.dart

## 🛠 Fonctionnalités
- ✨ **Génération de multiplications aléatoires** (tables de 3 à 9)
- ⏳ **Chronomètre de 1 minute** pour répondre aux 20 questions
- 🎯 **Sauvegarde des scores** avec `shared_preferences`
- 📊 **Visualisation des performances** avec des graphiques (`fl_chart`)
- 🔍 **Mode Entraînement et Mode Challenge** (futur ajout)

## 🌟 Technologies Utilisées
- **Flutter** (avec **FVM** pour la gestion des versions)
- **Provider** pour la gestion d'état
- **Shared Preferences** pour le stockage local
- **FL Chart** pour l'affichage des scores

## 🚀 Développement et Contribution
1. Fork et clone le projet :
   ```sh
   git clone https://github.com/ton-user/challenge_multiplication.git
   ```
2. Crée une branche :
   ```sh
   git checkout -b feature/nouvelle-fonctionnalite
   ```
3. Code et teste tes modifications
4. Commit et push :
   ```sh
   git commit -m "Ajout d'une nouvelle fonctionnalité"
   git push origin feature/nouvelle-fonctionnalite
   ```
5. Ouvre une Pull Request !

## 🌟 Auteur
- **Cyril ANDRE - Lilarisz** - Développeur Flutter

## 🌍 Licence
Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](https://opensource.org/licenses/MIT) pour plus de détails.

