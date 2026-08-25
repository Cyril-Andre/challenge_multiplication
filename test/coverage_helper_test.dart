import 'package:flutter_test/flutter_test.dart';

import 'package:challengemultiplication/challenge_multiplication_app.dart'
    as challenge_multiplication_app;
import 'package:challengemultiplication/common/services/storage_service.dart'
    as storage_service;
import 'package:challengemultiplication/common/widgets/animated_time_icon.dart'
    as animated_time_icon;
import 'package:challengemultiplication/common/widgets/app_scaffold.dart'
    as app_scaffold;
import 'package:challengemultiplication/features/game/models/multiplication.dart'
    as multiplication_model;
import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart'
    as game_play_screen_viewmodel;
import 'package:challengemultiplication/features/game/viewmodels/game_viewmodel.dart'
    as game_viewmodel;
import 'package:challengemultiplication/features/game/views/game_play_screen.dart'
    as game_play_screen;
import 'package:challengemultiplication/features/game/views/game_result_screen.dart'
    as game_result_screen;
import 'package:challengemultiplication/features/game/views/game_screen.dart'
    as game_screen;
import 'package:challengemultiplication/features/history/models/history_entry.dart'
    as history_entry_model;
import 'package:challengemultiplication/features/history/viewmodels/history_viewmodel.dart'
    as history_viewmodel;
import 'package:challengemultiplication/features/history/views/history_screen.dart'
    as history_screen;
import 'package:challengemultiplication/features/history/widget/score_card.dart'
    as score_card;
import 'package:challengemultiplication/features/home/views/home_screen.dart'
    as home_screen;
import 'package:challengemultiplication/features/players/models/player.dart'
    as player_model;
import 'package:challengemultiplication/features/players/services/player_service.dart'
    as player_service;
import 'package:challengemultiplication/features/players/viewmodels/player_auth_view_model.dart'
    as player_auth_viewmodel;
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart'
    as player_selection_viewmodel;
import 'package:challengemultiplication/features/players/viewmodels/registration_vew_model.dart'
    as registration_viewmodel;
import 'package:challengemultiplication/features/players/views/player_auth_screen.dart'
    as player_auth_screen;
import 'package:challengemultiplication/features/players/views/player_register_screen.dart'
    as player_register_screen;
import 'package:challengemultiplication/features/players/views/player_selection_screen.dart'
    as player_selection_screen;
import 'package:challengemultiplication/features/players/widgets/player_card.dart'
    as player_card;
import 'package:challengemultiplication/features/settings/models/player_settings.dart'
    as player_settings_model;
import 'package:challengemultiplication/features/settings/viewmodels/settings_viewmodel.dart'
    as settings_viewmodel;
import 'package:challengemultiplication/features/settings/views/settings_screen.dart'
    as settings_screen;
import 'package:challengemultiplication/features/settings/widgets/settings_form_widget.dart'
    as settings_form_widget;

void main() {
  test('loads application libraries for coverage reporting', () {
    final coverageAnchors = <Object?>[
      challenge_multiplication_app.ChallengeMultiplicationApp,
      storage_service.StorageService,
      animated_time_icon.AnimatedTimerIcon,
      app_scaffold.AppScaffold,
      multiplication_model.Multiplication,
      game_play_screen_viewmodel.GamePlayViewModel,
      game_viewmodel.GameViewModel,
      game_play_screen.GamePlayScreen,
      game_result_screen.GameResultScreen,
      game_screen.GameScreen,
      history_entry_model.HistoryEntry,
      history_viewmodel.HistoryViewModel,
      history_screen.HistoryScreen,
      score_card.ScoreChart,
      home_screen.HomeScreen,
      player_model.Player,
      player_service.PlayerService,
      player_auth_viewmodel.PlayerAuthViewModel,
      player_selection_viewmodel.PlayerSelectionViewModel,
      registration_viewmodel.PlayerRegisterViewModel,
      player_auth_screen.PlayerAuthScreen,
      player_register_screen.PlayerRegisterScreen,
      player_selection_screen.PlayerSelectionScreen,
      player_card.PlayerCard,
      player_settings_model.PlayerSettings,
      settings_viewmodel.SettingsViewModel,
      settings_screen.SettingsScreen,
      settings_form_widget.SettingsFormWidget,
    ];

    expect(coverageAnchors, isNotEmpty);
  });
}
