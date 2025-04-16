import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'dart:math' as math;

class PSSResultsScreen extends StatefulWidget {
  final int currentScore;

  const PSSResultsScreen({
    super.key,
    required this.currentScore,
  });

  @override
  State<PSSResultsScreen> createState() => _PSSResultsScreenState();
}

class _PSSResultsScreenState extends State<PSSResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.currentScore.toDouble(),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getStressLevel() {
    final score = widget.currentScore;
    if (score <= 17) return 'Low Stress';
    if (score <= 26) return 'Moderate Stress';
    return 'High Stress';
  }

  Color _getStressColor() {
    final score = widget.currentScore;
    if (score <= 17) {
      return AppTheme.primaryMint;
    } else if (score <= 26) {
      return const Color(0xFFE6B566); // Orange
    } else {
      return const Color(0xFFE67066); // Red
    }
  }

  String _getDescription() {
    final score = widget.currentScore;
    if (score <= 20) {
      return 'You\'re managing stress well. Keep practicing mindfulness and maintaining your healthy routines.';
    } else if (score <= 35) {
      return 'You\'re experiencing moderate stress. Consider incorporating more relaxation techniques into your daily routine.';
    } else {
      return 'Your stress levels are high. We recommend focusing on stress management and possibly seeking professional support.';
    }
  }

  List<String> _getRecommendations() {
    final score = widget.currentScore;
    if (score <= 17) {
      return [
        'Continue your mindfulness practice',
        'Maintain regular exercise',
        'Keep up your healthy sleep schedule',
      ];
    } else if (score <= 26) {
      return [
        'Try deep breathing exercises',
        'Practice daily meditation',
        'Take regular breaks during work',
        'Consider gentle yoga or stretching',
      ];
    } else {
      return [
        'Prioritize stress management',
        'Practice meditation twice daily',
        'Consider professional support',
        'Focus on quality sleep',
        'Limit caffeine and screen time',
      ];
    }
  }

  Widget _buildScoreIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: ScoreIndicatorPainter(
            score: _scoreAnimation.value,
            maxScore: 30,
            color: _getStressColor(),
            backgroundColor: AppTheme.primaryMint.withOpacity(0.1),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _scoreAnimation.value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'PSS Score',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: _buildScoreIndicator(),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getStressColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStressLevel(),
                              style: TextStyle(
                                color: _getStressColor(),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summary',
                                style: TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getDescription(),
                                style: TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendations',
                                style: TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ..._getRecommendations().map((recommendation) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryMint.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: AppTheme.primaryMint,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          recommendation,
                                          style: TextStyle(
                                            color: AppTheme.textLight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryMint,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Return to Home',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreIndicatorPainter extends CustomPainter {
  final double score;
  final double maxScore;
  final Color color;
  final Color backgroundColor;

  ScoreIndicatorPainter({
    required this.score,
    required this.maxScore,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.15;

    // Draw background arc (semicircle)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw semicircle background from left to right
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi, // Start from left (180 degrees)
      math.pi, // Draw half circle (180 degrees)
      false,
      backgroundPaint,
    );

    // Draw score arc
    final scorePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progress = score / maxScore;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi, // Start from left (180 degrees)
      math.pi * progress, // Draw progress portion
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScoreIndicatorPainter oldDelegate) {
    return oldDelegate.score != score ||
        oldDelegate.maxScore != maxScore ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
} 