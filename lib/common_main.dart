import 'dart:io';
import 'package:challengemultiplication/challenge_multiplication_app.dart';
import 'package:challengemultiplication/common/services/router.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_viewmodel.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class LocalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> commonMain(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (environment == "local") {
    HttpOverrides.global = LocalHttpOverrides();
  }
  String envPath = "assets/config/.env.$environment";

  if (kIsWeb) {
    envPath = "assets/assets/config/.env.$environment";
  }
  await dotenv.load(fileName: envPath);

  // Définir la route initiale avant d'instancier l'application
  final playerService = PlayerService();
  final players = await playerService.getPlayers();
  final String initialLocation = players.isEmpty ? '/player_register' : '/player_selection';

  // Initialiser le routeur avec la bonne route de départ
  setupRouter(initialLocation);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameViewModel()),
        ChangeNotifierProvider(create: (_) => GamePlayViewModel()),
        Provider<PlayerService>.value(value: playerService),
        ChangeNotifierProvider(create: (_) => PlayerSelectionViewModel(playerService)),
      ],
      child: const ChallengeMultiplicationApp(),
    ),
  );
}
