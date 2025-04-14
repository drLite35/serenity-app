import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PSSQuestionnaireScreen extends StatefulWidget {
  const PSSQuestionnaireScreen({super.key});

  @override
  State<PSSQuestionnaireScreen> createState() => _PSSQuestionnaireScreenState();
}

class _PSSQuestionnaireScreenState extends State<PSSQuestionnaireScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  int _currentQuestionIndex = 0;
  List<int> _answers = List.filled(5, 0);

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'In the last month, how often have you felt that you were unable to control the important things in your life?',
      'options': ['Never', 'Almost Never', 'Sometimes', 'Fairly Often', 'Very Often'],
    },
    {
      'question': 'In the last month, how often have you felt confident about your ability to handle your personal problems?',
      'options': ['Never', 'Almost Never', 'Sometimes', 'Fairly Often', 'Very Often'],
      'isReversed': true,
    },
    {
      'question': 'In the last month, how often have you felt that things were going your way?',
      'options': ['Never', 'Almost Never', 'Sometimes', 'Fairly Often', 'Very Often'],
      'isReversed': true,
    },
    {
      'question': 'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?',
      'options': ['Never', 'Almost Never', 'Sometimes', 'Fairly Often', 'Very Often'],
    },
    {
      'question': 'In the last month, how often have you felt nervous and stressed?',
      'options': ['Never', 'Almost Never', 'Sometimes', 'Fairly Often', 'Very Often'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _calculateTotalScore() {
    int total = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_questions[i]['isReversed'] == true) {
        total += (4 - _answers[i]);
      } else {
        total += _answers[i];
      }
    }
    return total;
  }

  String _getStressLevel(int score) {
    if (score <= 13) return 'Low Stress';
    if (score <= 26) return 'Moderate Stress';
    return 'High Stress';
  }

  String _getStressDescription(int score) {
    if (score <= 13) {
      return 'You are experiencing low levels of stress. This is generally considered a healthy range. Continue practicing stress management techniques to maintain this level.';
    } else if (score <= 26) {
      return 'You are experiencing moderate levels of stress. This is common and manageable. Consider incorporating more stress-reduction activities into your routine.';
    } else {
      return 'You are experiencing high levels of stress. It may be helpful to seek additional support and implement stress management strategies. Consider consulting with a healthcare professional.';
    }
  }

  Future<void> _saveResults() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final totalScore = _calculateTotalScore();
      await prefs.setInt('pssScore', totalScore);
      await prefs.setString('pssLevel', _getStressLevel(totalScore));
      await prefs.setString('pssDate', DateTime.now().toIso8601String());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PSSResultsScreen(
              score: totalScore,
              level: _getStressLevel(totalScore),
              description: _getStressDescription(totalScore),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving results: $e'),
            backgroundColor: Colors.red[300],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF7AB8B0).withOpacity(0.8),
                      const Color(0xFFB8E0D2).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.psychology_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Stress Assessment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _questions[_currentQuestionIndex]['question'],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF2C3E50),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ...List.generate(5, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: RadioListTile<int>(
                                  title: Text(
                                    _questions[_currentQuestionIndex]['options'][index],
                                    style: const TextStyle(
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  value: index,
                                  groupValue: _answers[_currentQuestionIndex],
                                  onChanged: (value) {
                                    setState(() {
                                      _answers[_currentQuestionIndex] = value!;
                                    });
                                  },
                                  activeColor: const Color(0xFF7AB8B0),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentQuestionIndex > 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentQuestionIndex--;
                                  _animationController.reset();
                                  _animationController.forward();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Previous',
                                style: TextStyle(
                                  color: Color(0xFF7AB8B0),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          if (_currentQuestionIndex < _questions.length - 1)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentQuestionIndex++;
                                  _animationController.reset();
                                  _animationController.forward();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7AB8B0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: _isLoading ? null : _saveResults,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7AB8B0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PSSResultsScreen extends StatelessWidget {
  final int score;
  final String level;
  final String description;

  const PSSResultsScreen({
    super.key,
    required this.score,
    required this.level,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF7AB8B0).withOpacity(0.8),
                      const Color(0xFFB8E0D2).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.analytics_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your Results',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PSS Score: $score',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Color(0xFF7AB8B0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          level,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2C3E50),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to next screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7AB8B0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 