import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/rating_service.dart';
import 'dart:math' as math;

class RatingHistoryChart extends StatelessWidget {
  final String userId;
  final RatingService ratingService;

  const RatingHistoryChart({
    required this.userId,
    required this.ratingService,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ratingService.getRatingHistory(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading rating history'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final ratingData = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return FlSpot(
            data['timestamp'].toDate().millisecondsSinceEpoch.toDouble(),
            data['rating'].toDouble(),
          );
        }).toList();

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                            value.toInt(),
                          );
                          return Text(
                            '${date.month}/${date.day}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: ratingData,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            _buildRecentChanges(snapshot.data!.docs),
          ],
        );
      },
    );
  }

  Widget _buildRecentChanges(List<QueryDocumentSnapshot> changes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: math.min(5, changes.length),
      itemBuilder: (context, index) {
        final data = changes[index].data() as Map<String, dynamic>;
        final change = data['change'] as double;
        final isPositive = change > 0;

        return ListTile(
          leading: Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.green : Colors.red,
          ),
          title: Text(
            'Rating ${isPositive ? "increased" : "decreased"} by ${change.abs().toStringAsFixed(2)}',
          ),
          subtitle: Text(
            'New rating: ${data['rating'].toStringAsFixed(2)}',
          ),
          trailing: Text(
            data['isDoubles'] ? 'Doubles' : 'Singles',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }
}
