import 'package:challenge_multiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challenge_multiplication/features/game/views/game_play_screen.dart';
import 'package:challenge_multiplication/features/game/views/game_result_screen.dart';
import 'package:challenge_multiplication/features/game/views/game_screen.dart';
import 'package:challenge_multiplication/features/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: '/game',
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<GamePlayViewModel>(context, listen: false).resetGame();
        });
        return const GameScreen();
      },
    ),
    GoRoute(
      path: '/game_play',
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<GamePlayViewModel>(context, listen: false).resetGame();
        });
        return const GamePlayScreen();
      },
    ),
    GoRoute(path: '/game_result', builder: (context, state) => const GameResultScreen()),

    /*    
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
*/
  ],
);
