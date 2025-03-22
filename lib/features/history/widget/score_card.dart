import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ScoreChart extends StatelessWidget {
  final List<HistoryEntry> entries;

  const ScoreChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: entries.length.toDouble() - 1, // Dynamique, n'affiche pas les dates
          minY: 0,
          maxY: 20, // Scores entre 0 et 20
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Pas de titres X
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5, // Optionnel, tu peux choisir 1, 2, ou 5 selon ta préférence
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 5, // Grille horizontale tous les 5 points
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                entries.length,
                (index) => FlSpot(
                  index.toDouble(), // X = index (progression dans le temps)
                  entries[index].score.toDouble(),
                ),
              ),
              isCurved: true,
              barWidth: 2,
              color: Theme.of(context).primaryColor,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
