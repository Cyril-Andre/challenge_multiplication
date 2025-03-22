import 'package:flutter/material.dart';
import 'package:challengemultiplication/features/players/models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const PlayerCard({super.key, required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(player.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
