# Challenge Multiplication

## 🌟 Description
Challenge Multiplication est une application mobile Flutter conçue pour aider les enfants à apprendre et maîtriser leurs tables de multiplication. Le jeu propose un challenge où le joueur doit répondre à 20 multiplications aléatoires (des tables de 3 à 9) en moins d'une minute. Les scores sont enregistrés pour suivre la progression du joueur à l'aide de graphiques.

## 📚 Architecture
L'application est organisée selon une architecture en oignon (Clean Architecture) avec MVVM (Model-View-ViewModel), en isolant chaque feature dans son propre répertoire :
```
lib/
├── features/            # Regroupe toutes les fonctionnalités
│   ├── game/            # Feature du jeu principal
│   │   ├── models/      # Modèles spécifiques à la fonctionnalité
│   │   ├── services/    # Services liés à la logique métier
│   │   ├── viewmodels/  # Logique de présentation et gestion d'état (Provider)
│   │   ├── views/       # Interfaces utilisateur (UI)
│   │   ├── widgets/     # Composants spécifiques à la feature
│   ├── history/         # Feature de l'historique des scores
│   │   ├── models/
│   │   ├── services/
│   │   ├── viewmodels/
│   │   ├── views/
│   │   ├── widgets/
│   ├── settings/        # Feature des paramètres
│   │   ├── models/
│   │   ├── services/
│   │   ├── viewmodels/
│   │   ├── views/
│   │   ├── widgets/
├── common/              # Composants réutilisables (widgets, modèles, services, viewmodels)
│   ├── widgets/         # Widgets partagés
│   ├── viewmodels/      # ViewModels communs
│   ├── models/          # Modèles de données partagés
│   ├── services/        # Services génériques
├── main.dart            # Point d'entrée de l'application

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

