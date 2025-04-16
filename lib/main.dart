import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/pss_questionnaire_screen.dart';
import 'screens/pss_results_screen.dart';
import 'screens/home_screen.dart';
import 'screens/biometric_connect_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/data_privacy_screen.dart';
import 'screens/exercises/breathing_exercise_screen.dart';
import 'screens/exercises/gratitude_exercise_screen.dart';
import 'screens/exercises/relaxation_exercise_screen.dart';
import 'screens/exercises/grounding_exercise_screen.dart';
import 'screens/exercises/coloring_exercise_screen.dart';
import 'screens/exercises/meditation_exercise_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryMint,
          secondary: AppTheme.secondaryMint,
          error: AppTheme.emergencyRed,
          background: AppTheme.backgroundLight,
        ),
        scaffoldBackgroundColor: AppTheme.backgroundLight,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppTheme.primaryMint),
          titleTextStyle: TextStyle(
            color: AppTheme.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppTheme.textDark),
          bodyMedium: TextStyle(color: AppTheme.textLight),
        ),
      ),
      home: const SplashScreen(),
      // Temporarily return to splash screen for onboarding route until we create the onboarding screen
      onGenerateRoute: (settings) {
        if (settings.name == '/onboarding') {
          return MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          );
        }
        if (settings.name == '/pss') {
          return MaterialPageRoute(
            builder: (context) => const PSSQuestionnaireScreen(),
          );
        }
        if (settings.name == '/pss-results') {
          final score = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => PSSResultsScreen(currentScore: score),
          );
        }
        if (settings.name == '/biometric_connect') {
          return MaterialPageRoute(
            builder: (context) => const BiometricConnectScreen(),
          );
        }
        if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        }
        if (settings.name == '/exercises') {
          return MaterialPageRoute(
            builder: (context) => const ExercisesScreen(),
          );
        }
        if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          );
        }
        if (settings.name == '/data-privacy') {
          return MaterialPageRoute(
            builder: (context) => const DataPrivacyScreen(),
          );
        }
        if (settings.name == '/exercises/breathing') {
          return MaterialPageRoute(
            builder: (context) => const BreathingExerciseScreen(),
          );
        }
        if (settings.name == '/exercises/gratitude') {
          return MaterialPageRoute(
            builder: (context) => const GratitudeExerciseScreen(),
          );
        }
        if (settings.name == '/exercises/relaxation') {
          return MaterialPageRoute(
            builder: (context) => const RelaxationExerciseScreen(),
          );
        }
        if (settings.name == '/exercises/grounding') {
          return MaterialPageRoute(
            builder: (context) => const GroundingExerciseScreen(),
          );
        }
        if (settings.name == '/exercises/coloring') {
          return MaterialPageRoute(
            builder: (context) => const ColoringExerciseScreen(),
          );
        }
        if (settings.name == '/exercises/meditation') {
          return MaterialPageRoute(
            builder: (context) => const MeditationExerciseScreen(),
          );
        }
        return null;
      },
    );
  }
}
