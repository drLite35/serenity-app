class ExerciseFeedback {
  final String exerciseName;
  final int rating;
  final DateTime timestamp;
  final String? notes;

  ExerciseFeedback({
    required this.exerciseName,
    required this.rating,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory ExerciseFeedback.fromJson(Map<String, dynamic> json) {
    return ExerciseFeedback(
      exerciseName: json['exerciseName'],
      rating: json['rating'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }
}

class ExerciseEffectiveness {
  final double averageRating;
  final int totalSessions;
  final double effectivenessPercentage;

  ExerciseEffectiveness({
    required this.averageRating,
    required this.totalSessions,
    required this.effectivenessPercentage,
  });
} 