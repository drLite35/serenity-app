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
import '../services/user_service.dart';

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
  final UserService _userService = UserService();
  String? _userName;
  bool _isStressed = false;
  String _currentThought = '';
  final List<String> _positiveThoughts = [
    'Every breath brings a moment of peace.',
    'You are stronger than you know.',
    'This moment is a gift, that\'s why it\'s called the present.',
    'Your mind is a garden, your thoughts are the seeds.',
    'Peace begins with a smile.',
    'In the midst of movement, find stillness.',
    'Today is full of endless possibilities.',
    'You are exactly where you need to be.',
  ];

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

    _loadUserName();
    _updateThought();
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
    if (_currentIndex == index) return; // Don't navigate if already on the page

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Home
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
        break;
      case 1: // Exercises
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExercisesScreen()),
        ).then((_) => setState(() => _currentIndex = 0));
        break;
      case 2: // Stats
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatsScreen()),
        ).then((_) => setState(() => _currentIndex = 0));
        break;
      case 3: // Settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        ).then((_) => setState(() => _currentIndex = 0));
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
    await Navigator.pushNamed(
      context,
      route,
      arguments: exerciseName,
    );
    
    // Show feedback dialog whenever returning from an exercise
    if (mounted) {
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

  Future<void> _loadUserName() async {
    final name = await _userService.getName();
    if (mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  void _updateThought() {
    setState(() {
      _currentThought = _positiveThoughts[Random().nextInt(_positiveThoughts.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serenity'),
        backgroundColor: AppTheme.primaryMint,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Hero(
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
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: AppTheme.primaryMint,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                        Text(
                          'Hello${_userName != null ? ', $_userName' : ''}!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How are you feeling today?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildStressModeSelector(),
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
                            child: _buildExerciseCard(exercise),
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

  Widget _buildExerciseCard(Exercise exercise) {
    return Hero(
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: exercise.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(85 + Random().nextInt(10))}% effective', // Mock effectiveness
                              style: TextStyle(
                                color: exercise.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildRecommendedExercise() {
    // Get a random exercise from our list
    final exercise = randomExercises[Random().nextInt(randomExercises.length)];
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: exercise.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: exercise.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              exercise.icon,
              color: exercise.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try this exercise:',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  exercise.title,
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: exercise.color,
            ),
            onPressed: () => _navigateToExercise(context, exercise.title),
          ),
        ],
      ),
    );
  }

  Widget _buildStressModeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryMint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sentiment_satisfied_alt,
                  color: !_isStressed ? AppTheme.primaryMint : AppTheme.textLight,
                ),
                Expanded(
                  child: Switch(
                    value: _isStressed,
                    onChanged: (value) {
                      setState(() {
                        _isStressed = value;
                        if (!_isStressed) {
                          _updateThought();
                        }
                      });
                    },
                    activeColor: AppTheme.primaryMint,
                    activeTrackColor: AppTheme.primaryMint.withOpacity(0.4),
                    inactiveThumbColor: AppTheme.primaryMint,
                    inactiveTrackColor: AppTheme.primaryMint.withOpacity(0.2),
                  ),
                ),
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: _isStressed ? AppTheme.primaryMint : AppTheme.textLight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!_isStressed)
            Text(
              _currentThought,
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _buildRecommendedExercise(),
        ],
      ),
    );
  }
} 