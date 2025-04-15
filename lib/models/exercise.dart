import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Exercise {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  const Exercise({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}

// Define the list of exercises
final List<Exercise> exercises = [
  Exercise(
    title: 'Deep Breathing',
    description: 'Calm your mind with guided breathing exercises',
    icon: Icons.air,
    color: const Color(0xFF66D1B8),
    route: '/exercises/breathing',
  ),
  Exercise(
    title: 'Gratitude Journal',
    description: 'Practice daily gratitude for mental well-being',
    icon: Icons.book,
    color: const Color(0xFFFFB347),
    route: '/exercises/gratitude',
  ),
  Exercise(
    title: 'Muscle Relaxation',
    description: 'Release tension through progressive relaxation',
    icon: Icons.self_improvement,
    color: const Color(0xFF66A5E6),
    route: '/exercises/relaxation',
  ),
  Exercise(
    title: 'Grounding',
    description: '5-4-3-2-1 technique for anxiety relief',
    icon: Icons.spa,
    color: const Color(0xFFB39DDB),
    route: '/exercises/grounding',
  ),
  Exercise(
    title: 'Mindful Coloring',
    description: 'Find peace through creative expression',
    icon: Icons.palette,
    color: const Color(0xFFFF7F7F),
    route: '/exercises/coloring',
  ),
  Exercise(
    title: 'Guided Meditation',
    description: 'Short guided sessions for inner peace',
    icon: Icons.headphones,
    color: const Color(0xFF66A5E6),
    route: '/exercises/meditation',
  ),
]; 