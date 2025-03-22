import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerAuthScreen extends StatelessWidget {
  final String playerName;
  final String correctPin;
  final VoidCallback onSuccess;

  const PlayerAuthScreen({
    super.key,
    required this.playerName,
    required this.correctPin,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerAuthViewModel(correctPin: correctPin, onSuccess: onSuccess),
      child: AppScaffold(
        body: Consumer<PlayerAuthViewModel>(
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
                        Text("Entrez le PIN de $playerName", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                index < viewModel.enteredPin.length ? Icons.circle : Icons.circle_outlined,
                                size: 20,
                                color: viewModel.hasError ? Colors.red : Colors.blue,
                              ),
                            ),
                          ),
                        ),

                        if (viewModel.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("PIN incorrect", style: TextStyle(color: Colors.red)),
                          ),

                        SizedBox(height: 30),

                        _buildNumpad(viewModel),

                        SizedBox(height: 20), // Un peu d'espace bas
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

  Widget _buildNumpad(PlayerAuthViewModel viewModel) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['⌫', '0', '✅']
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((label) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildNumpadButton(label, viewModel),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNumpadButton(String label, PlayerAuthViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        if (label == '⌫') {
          viewModel.removeDigit();
        } else if (label == '✅') {
          if (viewModel.isPinComplete && !viewModel.hasError) {
            viewModel.onSuccess();
          }
        } else {
          viewModel.addDigit(label);
        }
      },
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: label == '✅' ? Colors.green : Colors.blueGrey[200],
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
