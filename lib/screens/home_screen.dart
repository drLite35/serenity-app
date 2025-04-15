import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../models/exercise.dart';
import 'package:url_launcher/url_launcher.dart';
import 'exercises_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/exercise_feedback_dialog.dart';
import '../services/exercise_feedback_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late List<Exercise> randomExercises;
  bool showEmergencyContact = false;
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    randomExercises = List.from(exercises)..shuffle(Random());
    randomExercises = randomExercises.take(3).toList();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExercisesScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatsScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  void _navigateToExercise(BuildContext context, String exerciseName) async {
    String route = '';
    switch (exerciseName) {
      case 'Deep Breathing':
        route = '/exercises/breathing';
        break;
      case 'Gratitude Journal':
        route = '/exercises/gratitude';
        break;
      case 'Muscle Relaxation':
        route = '/exercises/relaxation';
        break;
      case 'Grounding':
        route = '/exercises/grounding';
        break;
      case 'Mindful Coloring':
        route = '/exercises/coloring';
        break;
      case 'Guided Meditation':
        route = '/exercises/meditation';
        break;
      default:
        print('Unknown exercise: $exerciseName');
        return;
    }
    
    print('Navigating to route: $route for exercise: $exerciseName');
    final result = await Navigator.pushNamed(
      context,
      route,
      arguments: exerciseName,
    );
    
    print('Exercise result: $result');
    if (result == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ExerciseFeedbackDialog(
          exerciseName: exerciseName,
          feedbackService: ExerciseFeedbackService(prefs),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE6F3F1).withOpacity(0.8),
                    const Color(0xFFF5F9F6).withOpacity(0.8),
                  ],
                ),
              ),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.textLight,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'How are you feeling?',
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: AppTheme.textDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Hero(
                              tag: 'profile',
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/profile');
                                  },
                                  customBorder: const CircleBorder(),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.primaryMint.withOpacity(0.5),
                                          AppTheme.secondaryMint.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.person,
                                        color: AppTheme.primaryMint,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Your Stress Level',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryMint.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 1,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: AppTheme.accentGray.withOpacity(0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            days[value.toInt()],
                                            style: TextStyle(
                                              color: AppTheme.textLight,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: AppTheme.textLight,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 3),
                                    FlSpot(1, 2),
                                    FlSpot(2, 4),
                                    FlSpot(3, 3),
                                    FlSpot(4, 2),
                                    FlSpot(5, 3),
                                    FlSpot(6, 2),
                                  ],
                                  isCurved: true,
                                  color: AppTheme.primaryMint,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: AppTheme.primaryMint,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryMint.withOpacity(0.2),
                                        AppTheme.primaryMint.withOpacity(0.0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recommended Exercises',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/exercises');
                              },
                              icon: const Icon(Icons.add_circle_outline, size: 18),
                              label: const Text('See All'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryMint,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final exercise = randomExercises[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: index == 0 ? _scaleAnimation.value : 1.0,
                                child: child,
                              );
                            },
                            child: Hero(
                              tag: 'exercise_${exercise.title}',
                              child: Material(
                                color: Colors.transparent,
                                child: Card(
                                  elevation: 4,
                                  shadowColor: exercise.color.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () => _navigateToExercise(context, exercise.title),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            exercise.color.withOpacity(0.15),
                                            exercise.color.withOpacity(0.05),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: exercise.color.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              exercise.icon,
                                              size: 28,
                                              color: exercise.color,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  exercise.title,
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: AppTheme.textDark,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  exercise.description,
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: AppTheme.textLight,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: exercise.color,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: randomExercises.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                backgroundColor: AppTheme.emergencyRed,
                onPressed: () {
                  setState(() {
                    showEmergencyContact = !showEmergencyContact;
                  });
                },
                child: const Icon(Icons.emergency, color: Colors.white),
              ),
            ),
            if (showEmergencyContact)
              Positioned(
                right: 16,
                bottom: 80,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.emergencyRed.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emergency,
                                color: AppTheme.emergencyRed,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Emergency Contact',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.emergencyRed.withOpacity(0.1),
                            child: Icon(
                              Icons.phone,
                              color: AppTheme.emergencyRed,
                            ),
                          ),
                          title: const Text(
                            'Crisis Helpline',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text('1-800-273-8255'),
                          onTap: () => _launchUrl('tel:1-800-273-8255'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Available 24/7 for confidential support',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textLight,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onNavigationTap,
          selectedItemColor: AppTheme.primaryMint,
          unselectedItemColor: AppTheme.textLight,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
} 