import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GroundingExerciseScreen extends StatefulWidget {
  const GroundingExerciseScreen({super.key});

  @override
  State<GroundingExerciseScreen> createState() => _GroundingExerciseScreenState();
}

class _GroundingExerciseScreenState extends State<GroundingExerciseScreen> {
  int _currentStep = 0;
  final List<Map<String, dynamic>> _steps = [
    {
      'title': '5 Things You Can See',
      'description': 'Look around and notice 5 things you can see.',
      'icon': Icons.remove_red_eye,
      'items': List.generate(5, (index) => {'text': '', 'checked': false}),
    },
    {
      'title': '4 Things You Can Touch',
      'description': 'Notice 4 things you can touch and feel their texture.',
      'icon': Icons.touch_app,
      'items': List.generate(4, (index) => {'text': '', 'checked': false}),
    },
    {
      'title': '3 Things You Can Hear',
      'description': 'Listen carefully and identify 3 sounds you can hear.',
      'icon': Icons.hearing,
      'items': List.generate(3, (index) => {'text': '', 'checked': false}),
    },
    {
      'title': '2 Things You Can Smell',
      'description': 'Take a deep breath and notice 2 things you can smell.',
      'icon': Icons.air,
      'items': List.generate(2, (index) => {'text': '', 'checked': false}),
    },
    {
      'title': '1 Thing You Can Taste',
      'description': 'Focus on 1 thing you can taste right now.',
      'icon': Icons.restaurant,
      'items': List.generate(1, (index) => {'text': '', 'checked': false}),
    },
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _toggleItem(int itemIndex) {
    setState(() {
      _steps[_currentStep]['items'][itemIndex]['checked'] = 
          !_steps[_currentStep]['items'][itemIndex]['checked'];
    });
  }

  void _updateItemText(int itemIndex, String text) {
    setState(() {
      _steps[_currentStep]['items'][itemIndex]['text'] = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grounding Exercise'),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      step['icon'] as IconData,
                      size: 48,
                      color: AppTheme.primaryMint,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      step['title'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['description'] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ...List.generate(
                      (step['items'] as List).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppTheme.primaryMint.withOpacity(0.2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: step['items'][index]['checked'],
                                  onChanged: (_) => _toggleItem(index),
                                  activeColor: AppTheme.primaryMint,
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter what you notice...',
                                      border: InputBorder.none,
                                      enabled: !step['items'][index]['checked'],
                                    ),
                                    onChanged: (text) => _updateItemText(index, text),
                                    enabled: !step['items'][index]['checked'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryMint,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentStep < _steps.length - 1 ? 'Next' : 'Finish',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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