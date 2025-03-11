import 'dart:io';
import 'package:challenge_multiplication/challenge_multiplication_app.dart';
import 'package:challenge_multiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challenge_multiplication/features/game/viewmodels/game_viewmodel.dart';
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

    runApp(MultiProvider(providers: 
    [
      ChangeNotifierProvider(create: (_) => GameViewModel()),
      ChangeNotifierProvider(create: (_) => GamePlayViewModel())
    ], 
    child: const ChallengeMultiplicationApp()));
}
