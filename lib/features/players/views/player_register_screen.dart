import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/registration_vew_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PlayerRegisterScreen extends StatelessWidget {
  const PlayerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerRegisterViewModel(playerService: Provider.of<PlayerService>(context, listen: false)),
      child: AppScaffold(
        body: Consumer<PlayerRegisterViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 32, // 32 = padding vertical
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNameInput(),
                        SizedBox(height: 20),
                        buildPinDisplay(),
                        SizedBox(height: 20),
                        buildNumpad(context),
                        SizedBox(height: 20),
                        buildRegisterButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildNameInput() {
    return Consumer<PlayerRegisterViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          key: Key("PlayerName"),
          onChanged: viewModel.setName,
          decoration: InputDecoration(labelText: "Choisis un pseudo"),
        );
      },
    );
  }

  Widget buildPinDisplay() {
    return Consumer<PlayerRegisterViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Text("Choisis un code PIN"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    index < viewModel.enteredPin.length ? Icons.circle : Icons.circle_outlined,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildNumpad(BuildContext context) {
    return Consumer<PlayerRegisterViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            for (var row in [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['⌫', '0', '✅'],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((label) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildNumpadButton(label, viewModel, context),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  Widget buildNumpadButton(String label, PlayerRegisterViewModel viewModel, BuildContext context) {
    return GestureDetector(
      key: Key(label),
      onTap: () async {
        if (label == '⌫') {
          viewModel.removeDigit();
        } else if (label == '✅' && viewModel.canRegister) {
          await viewModel.registerPlayer();
          if (context.mounted) {
            context.go('/player_selection');
          }
        } else {
          viewModel.addDigit(label);
        }
      },
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: label == '✅' ? Colors.green : Colors.blueGrey[200], shape: BoxShape.circle),
        child: Text(label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Consumer<PlayerRegisterViewModel>(
      builder: (context, viewModel, child) {
        return ElevatedButton(
          key: Key("PlayerSelection"),
          onPressed: viewModel.canRegister
              ? () async {
                  await viewModel.registerPlayer();
                  context.go("/player_selection");
                }
              : null,
          child: Text("S'inscrire"),
        );
      },
    );
  }
}
