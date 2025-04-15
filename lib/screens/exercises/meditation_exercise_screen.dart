import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/theme.dart';
import '../../widgets/exercise_feedback_dialog.dart';
import '../../services/exercise_feedback_service.dart';

class MeditationExerciseScreen extends StatefulWidget {
  const MeditationExerciseScreen({super.key});

  @override
  State<MeditationExerciseScreen> createState() => _MeditationExerciseScreenState();
}

class _MeditationExerciseScreenState extends State<MeditationExerciseScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _selectedDuration = 5; // minutes
  late ExerciseFeedbackService _feedbackService;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeFeedbackService();
  }

  Future<void> _initializeFeedbackService() async {
    final prefs = await SharedPreferences.getInstance();
    _feedbackService = ExerciseFeedbackService(prefs);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMeditationSound() async {
    await _audioPlayer.play(AssetSource('sounds/meditation.mp3'));
  }

  void _toggleExercise() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playMeditationSound();
      } else {
        _audioPlayer.stop();
        if (!_isCompleted) {
          _showFeedbackDialog();
        }
      }
    });
  }

  void _updateDuration(int minutes) {
    setState(() {
      _selectedDuration = minutes;
      if (_isPlaying) {
        _audioPlayer.stop();
        _isPlaying = false;
      }
    });
  }

  void _showFeedbackDialog() {
    setState(() {
      _isCompleted = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExerciseFeedbackDialog(
        exerciseName: 'Guided Meditation',
        feedbackService: _feedbackService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: _selectedDuration,
                    items: [5, 10, 15, 20].map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text('$minutes min'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) _updateDuration(value);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF66A5E6).withOpacity(0.2),
                          const Color(0xFF66A5E6).withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _isPlaying ? Icons.headphones : Icons.headphones_outlined,
                        size: 64,
                        color: const Color(0xFF66A5E6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _isPlaying ? 'Focus on your breath...' : 'Ready to begin?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_selectedDuration minutes meditation',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                onPressed: _toggleExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66A5E6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isPlaying ? 'Pause' : 'Start',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 