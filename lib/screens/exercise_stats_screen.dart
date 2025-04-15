import 'package:flutter/material.dart';
import '../models/exercise_feedback.dart';
import '../services/exercise_feedback_service.dart';

class ExerciseStatsScreen extends StatefulWidget {
  final ExerciseFeedbackService feedbackService;

  const ExerciseStatsScreen({
    Key? key,
    required this.feedbackService,
  }) : super(key: key);

  @override
  State<ExerciseStatsScreen> createState() => _ExerciseStatsScreenState();
}

class _ExerciseStatsScreenState extends State<ExerciseStatsScreen> {
  late Future<Map<String, ExerciseEffectiveness>> _effectivenessFuture;

  @override
  void initState() {
    super.initState();
    _effectivenessFuture = widget.feedbackService.getAllExerciseEffectiveness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Statistics'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, ExerciseEffectiveness>>(
        future: _effectivenessFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading statistics: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final effectivenessMap = snapshot.data ?? {};
          if (effectivenessMap.isEmpty) {
            return const Center(
              child: Text(
                'No exercise data available yet.\nComplete exercises to see your statistics.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: effectivenessMap.length,
            itemBuilder: (context, index) {
              final exerciseName = effectivenessMap.keys.elementAt(index);
              final effectiveness = effectivenessMap[exerciseName]!;
              return _buildExerciseCard(exerciseName, effectiveness);
            },
          );
        },
      ),
    );
  }

  Widget _buildExerciseCard(String exerciseName, ExerciseEffectiveness effectiveness) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exerciseName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Effectiveness',
                  '${effectiveness.effectivenessPercentage.toStringAsFixed(1)}%',
                  Icons.trending_up,
                ),
                _buildStatItem(
                  'Sessions',
                  effectiveness.totalSessions.toString(),
                  Icons.fitness_center,
                ),
                _buildStatItem(
                  'Avg Rating',
                  effectiveness.averageRating.toStringAsFixed(1),
                  Icons.star,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
} 