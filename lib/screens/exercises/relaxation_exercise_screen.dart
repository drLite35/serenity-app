import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/theme.dart';

class RelaxationExerciseScreen extends StatefulWidget {
  const RelaxationExerciseScreen({super.key});

  @override
  State<RelaxationExerciseScreen> createState() => _RelaxationExerciseScreenState();
}

class _RelaxationExerciseScreenState extends State<RelaxationExerciseScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  int _currentStep = 0;
  bool _isPlaying = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Hands and Arms',
      'instruction': 'Tighten your hands into fists and hold for 5 seconds, then release.',
      'icon': Icons.back_hand,
    },
    {
      'title': 'Shoulders',
      'instruction': 'Raise your shoulders towards your ears and hold for 5 seconds, then release.',
      'icon': Icons.accessibility_new,
    },
    {
      'title': 'Face',
      'instruction': 'Squeeze your eyes shut and scrunch your face for 5 seconds, then release.',
      'icon': Icons.face,
    },
    {
      'title': 'Chest',
      'instruction': 'Take a deep breath and hold it for 5 seconds, then exhale slowly.',
      'icon': Icons.favorite,
    },
    {
      'title': 'Legs',
      'instruction': 'Tighten your leg muscles for 5 seconds, then release.',
      'icon': Icons.directions_run,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playInstruction() async {
    await _audioPlayer.play(AssetSource('sounds/relaxation.mp3'));
  }

  void _toggleExercise() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.forward();
        _playInstruction();
      } else {
        _controller.stop();
        _audioPlayer.stop();
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _controller.reset();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _controller.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progressive Relaxation'),
        backgroundColor: AppTheme.primaryMint,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: AppTheme.primaryMint.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMint),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      step['icon'] as IconData,
                      size: 80,
                      color: AppTheme.primaryMint,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      step['title'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      step['instruction'] as String,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: AppTheme.primaryMint.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMint),
                          strokeWidth: 8,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentStep > 0 ? _previousStep : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryMint,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _toggleExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryMint,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                  TextButton.icon(
                    onPressed: _nextStep,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryMint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 