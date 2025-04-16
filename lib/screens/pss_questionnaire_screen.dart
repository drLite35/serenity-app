import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PSSQuestionnaireScreen extends StatefulWidget {
  const PSSQuestionnaireScreen({super.key});

  @override
  State<PSSQuestionnaireScreen> createState() => _PSSQuestionnaireScreenState();
}

class _PSSQuestionnaireScreenState extends State<PSSQuestionnaireScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentQuestion = 0;
  final List<int?> _answers = List.filled(13, null);

  final List<String> _questions = [
    'In the last month, how often have you been upset because of something that happened unexpectedly?',
    'In the last month, how often have you felt that you were unable to control the important things in your life?',
    'In the last month, how often have you felt nervous and stressed?',
    'In the last month, how often have you felt confident about your ability to handle your personal problems?',
    'In the last month, how often have you felt that things were going your way?',
    'In the last month, how often have you found that you could not cope with all the things that you had to do?',
    'In the last month, how often have you been able to control irritations in your life?',
    'In the last month, how often have you felt that you were on top of things?',
    'In the last month, how often have you been angered because of things that were outside of your control?',
    'In the last month, how often have you felt difficulties were piling up and you could not overcome them?',
    'What is your typical blood pressure range?',
    'How would you rate your baseline stress level?',
    'What is your typical pulse rate range?',
  ];

  final List<String> _options = [
    'Never',
    'Almost Never',
    'Sometimes',
    'Fairly Often',
    'Very Often',
  ];

  final List<String> _bpOptions = [
    'Low',
    'Normal',
    'High',
  ];

  final List<String> _baselineOptions = [
    'Low',
    'Normal',
    'High',
  ];

  final List<String> _pulseOptions = [
    'Low',
    'Normal',
    'High',
  ];

  List<String> _getOptionsForQuestion(int questionIndex) {
    if (questionIndex == 10) {
      return _bpOptions;
    } else if (questionIndex == 11) {
      return _baselineOptions;
    } else if (questionIndex == 12) {
      return _pulseOptions;
    }
    return _options;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _showResults();
    }
  }

  void _showResults() {
    // Validate that we have all 13 responses
    if (_answers.any((answer) => answer == null)) {
      // Handle incomplete responses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions to see your results.'),
        ),
      );
      return;
    }

    // Calculate raw score for first 10 questions (PSS questions)
    int rawScore = 0;
    for (int i = 0; i < 10; i++) {
      if ([3, 4, 6, 7].contains(i)) {
        // Reverse scoring for positive items (4,5,7,8)
        rawScore += 4 - (_answers[i] ?? 0);
      } else {
        // Normal scoring for negative items
        rawScore += _answers[i] ?? 0;
      }
    }

    // Calculate additional metrics score (last 3 questions)
    int additionalScore = 0;
    for (int i = 10; i < 13; i++) {
      additionalScore += _answers[i] ?? 0;
    }

    // Normalize the PSS score to 30-point scale
    // Formula: (rawScore / maxPossibleScore) * 30
    double normalizedScore = (rawScore / 40) * 30; // 40 is max possible for first 10 questions
    
    // Round to 2 decimal places
    normalizedScore = double.parse(normalizedScore.toStringAsFixed(2));

    // Determine stress level
    String stressLevel;
    if (normalizedScore <= 10) {
      stressLevel = 'Low';
    } else if (normalizedScore <= 20) {
      stressLevel = 'Moderate';
    } else {
      stressLevel = 'High';
    }

    // Get additional metrics
    int? bpRange = _answers[10];
    int? baselinePss = _answers[11];
    int? pulseRange = _answers[12];
    
    // Calculate baseline PSS level based on additional metrics
    int baselineLevel = 1; // Default to normal
    if (bpRange != null && pulseRange != null) {
      // Higher values indicate higher stress
      int stressIndicators = 0;
      
      // BP contribution
      if (bpRange == 2) stressIndicators++; // High BP
      if (bpRange == 0) stressIndicators--; // Low BP
      
      // Pulse contribution
      if (pulseRange == 2) stressIndicators++; // High pulse
      if (pulseRange == 0) stressIndicators--; // Low pulse
      
      // Determine baseline level
      if (stressIndicators >= 1) {
        baselineLevel = 2; // High stress
      } else if (stressIndicators <= -1) {
        baselineLevel = 0; // Low stress
      }
    }
    
    // Navigate to results screen with all scores
    Navigator.pushReplacementNamed(
      context, 
      '/pss_results', 
      arguments: {
        'score': normalizedScore,
        'stressLevel': stressLevel,
        'bpRange': bpRange,
        'baselinePss': baselinePss ?? baselineLevel,
        'pulseRange': pulseRange,
      }
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.primaryMint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth * ((_currentQuestion + 1) / _questions.length),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryMint,
                      AppTheme.primaryMint.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryMint.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryMint.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        question,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppTheme.textDark,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionButton(int index, String option) {
    final bool isSelected = _answers[_currentQuestion] == index;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _answers[_currentQuestion] = index;
          });
          Future.delayed(const Duration(milliseconds: 300), _nextQuestion);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryMint.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.primaryMint : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryMint.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryMint
                        : AppTheme.textLight.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryMint,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                option,
                style: TextStyle(
                  color: isSelected ? AppTheme.textDark : AppTheme.textLight,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppTheme.primaryMint.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestion + 1} of ${_questions.length}',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${((_currentQuestion + 1) / _questions.length * 100).round()}%',
                      style: TextStyle(
                        color: AppTheme.primaryMint,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildProgressBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _currentQuestion = page;
                    });
                    _fadeController.reset();
                    _fadeController.forward();
                  },
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildQuestionCard(_questions[index]),
                          const SizedBox(height: 24),
                          ...List.generate(
                            _getOptionsForQuestion(index).length,
                            (optionIndex) => _buildOptionButton(
                              optionIndex,
                              _getOptionsForQuestion(index)[optionIndex],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 