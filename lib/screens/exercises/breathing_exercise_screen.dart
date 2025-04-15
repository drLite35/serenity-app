import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/theme.dart';
import '../../widgets/exercise_feedback_dialog.dart';
import '../../services/exercise_feedback_service.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _selectedDuration = 5; // minutes
  int _currentCycle = 0;
  int _totalCycles = 0;
  late ExerciseFeedbackService _feedbackService;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _totalCycles = _selectedDuration * 60 ~/ 8; // 8 seconds per cycle
    _initializeFeedbackService();
  }

  Future<void> _initializeFeedbackService() async {
    final prefs = await SharedPreferences.getInstance();
    _feedbackService = ExerciseFeedbackService(prefs);
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBreathingSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/breathing.mp3'));
    } catch (e) {
      print('Audio file not found: $e');
      // Continue without audio
    }
  }

  void _toggleExercise() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat(reverse: true);
        _playBreathingSound();
      } else {
        _controller.stop();
        _audioPlayer.stop();
        Navigator.pop(context, true); // Return true to indicate completion
      }
    });
  }

  void _updateDuration(int minutes) {
    setState(() {
      _selectedDuration = minutes;
      _totalCycles = minutes * 60 ~/ 8;
      _currentCycle = 0;
      if (_isPlaying) {
        _controller.stop();
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
        exerciseName: 'Deep Breathing',
        feedbackService: _feedbackService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _isCompleted);
        return false;
      },
      child: Scaffold(
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
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.primaryMint.withOpacity(0.2),
                                  AppTheme.primaryMint.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _isPlaying ? Icons.air : Icons.air_outlined,
                                size: 64,
                                color: AppTheme.primaryMint,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _isPlaying ? 'Breathe in...' : 'Ready to begin?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cycle ${_currentCycle + 1} of $_totalCycles',
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
                    backgroundColor: AppTheme.primaryMint,
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
      ),
    );
  }
} 