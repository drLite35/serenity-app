import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_feedback.dart';

class ExerciseFeedbackService {
  static const String _feedbackKey = 'exercise_feedback';
  final SharedPreferences _prefs;

  ExerciseFeedbackService(this._prefs);

  Future<void> saveFeedback(ExerciseFeedback feedback) async {
    final List<ExerciseFeedback> allFeedback = await getAllFeedback();
    allFeedback.add(feedback);
    
    final List<Map<String, dynamic>> jsonList = 
        allFeedback.map((f) => f.toJson()).toList();
    
    await _prefs.setString(_feedbackKey, jsonEncode(jsonList));
  }

  Future<List<ExerciseFeedback>> getAllFeedback() async {
    final String? jsonString = _prefs.getString(_feedbackKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => ExerciseFeedback.fromJson(json))
        .toList();
  }

  Future<List<ExerciseFeedback>> getFeedbackForExercise(String exerciseName) async {
    final allFeedback = await getAllFeedback();
    return allFeedback
        .where((feedback) => feedback.exerciseName == exerciseName)
        .toList();
  }

  Future<ExerciseEffectiveness> getEffectivenessForExercise(String exerciseName) async {
    final feedback = await getFeedbackForExercise(exerciseName);
    if (feedback.isEmpty) {
      return ExerciseEffectiveness(
        averageRating: 0,
        totalSessions: 0,
        effectivenessPercentage: 0,
      );
    }

    final totalRating = feedback.fold<int>(0, (sum, f) => sum + f.rating);
    final averageRating = totalRating / feedback.length;
    final effectivenessPercentage = (averageRating / 5.0) * 100;

    return ExerciseEffectiveness(
      averageRating: averageRating,
      totalSessions: feedback.length,
      effectivenessPercentage: effectivenessPercentage,
    );
  }

  Future<Map<String, ExerciseEffectiveness>> getAllExerciseEffectiveness() async {
    final allFeedback = await getAllFeedback();
    final Map<String, ExerciseEffectiveness> effectivenessMap = {};

    for (final feedback in allFeedback) {
      if (!effectivenessMap.containsKey(feedback.exerciseName)) {
        effectivenessMap[feedback.exerciseName] = 
            await getEffectivenessForExercise(feedback.exerciseName);
      }
    }

    return effectivenessMap;
  }
} 