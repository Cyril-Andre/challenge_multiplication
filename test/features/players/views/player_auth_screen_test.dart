import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/views/player_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('PlayerAuthScreen', () {
    testWidgets('shows the selected player prompt', (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service, onSuccess: () {}));

      expect(find.text('Entrez le PIN de Alice'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('⌫'), findsOneWidget);
    });

    testWidgets('calls success when the entered pin is correct',
        (tester) async {
      final service = PlayerService();
      var successes = 0;
      addTearDown(service.dispose);

      await tester.pumpWidget(
        _app(
          service,
          onSuccess: () {
            successes++;
          },
        ),
      );

      for (final digit in ['1', '2', '3', '4']) {
        await tester.tap(find.text(digit));
        await tester.pump();
      }

      expect(successes, 1);
      expect(find.text('PIN incorrect'), findsNothing);
    });

    testWidgets('shows and clears an incorrect pin error', (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service, onSuccess: () {}));

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.text('0'));
        await tester.pump();
      }

      expect(find.text('PIN incorrect'), findsOneWidget);

      await tester.tap(find.text('⌫'));
      await tester.pump();

      expect(find.text('PIN incorrect'), findsNothing);
    });
  });
}

Widget _app(PlayerService service, {required VoidCallback onSuccess}) {
  return ChangeNotifierProvider<PlayerService>.value(
    value: service,
    child: MaterialApp(
      home: PlayerAuthScreen(
        playerName: 'Alice',
        correctPin: '1234',
        onSuccess: onSuccess,
      ),
    ),
  );
}
