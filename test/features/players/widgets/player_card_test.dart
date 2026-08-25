import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/widgets/player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the player name and handles taps', (tester) async {
    var taps = 0;
    final player = Player(
      id: 'player-1',
      name: 'Alice',
      pin: '1234',
      settings: {},
      history: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlayerCard(
            player: player,
            onTap: () {
              taps++;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);

    await tester.tap(find.text('Alice'));

    expect(taps, 1);
  });
}
