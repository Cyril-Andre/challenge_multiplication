import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('AppScaffold', () {
    testWidgets('shows the base title without a selected player',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(
        ChangeNotifierProvider<PlayerService>.value(
          value: service,
          child: const MaterialApp(
            home: AppScaffold(body: Text('Body')),
          ),
        ),
      );

      expect(find.text('Challenge Multiplications'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('shows the selected player in the title', (tester) async {
      final service = PlayerService()
        ..currentPlayer = Player(
          id: 'player-1',
          name: 'Alice',
          pin: '1234',
          settings: {},
          history: [],
        );
      addTearDown(service.dispose);

      await tester.pumpWidget(
        ChangeNotifierProvider<PlayerService>.value(
          value: service,
          child: const MaterialApp(
            home: AppScaffold(body: Text('Body')),
          ),
        ),
      );

      expect(find.text('Challenge Multiplications - Alice'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });
  });
}
