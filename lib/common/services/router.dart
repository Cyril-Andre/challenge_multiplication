import 'package:challengemultiplication/features/game/views/game_play_screen.dart';
import 'package:challengemultiplication/features/game/views/game_result_screen.dart';
import 'package:challengemultiplication/features/game/views/game_screen.dart';
import 'package:challengemultiplication/features/history/views/history_screen.dart';
import 'package:challengemultiplication/features/home/views/home_screen.dart';
import 'package:challengemultiplication/features/players/views/player_register_screen.dart';
import 'package:challengemultiplication/features/players/views/player_selection_screen.dart';
import 'package:challengemultiplication/features/settings/views/settings_screen.dart';
import 'package:go_router/go_router.dart';

late GoRouter router; // Déclaration du routeur en global

void setupRouter(String initialLocation) {
  router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
          path: '/player_register',
          builder: (context, state) => PlayerRegisterScreen()),
      GoRoute(
          path: '/player_selection',
          builder: (context, state) => PlayerSelectionScreen()),
      GoRoute(
        path: '/game',
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: '/game_play',
        builder: (context, state) => const GamePlayScreen(),
      ),
      GoRoute(
          path: '/game_result',
          builder: (context, state) => const GameResultScreen()),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
