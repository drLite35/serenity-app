import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;
  late AnimationController _glowController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<double> _contentSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Content animations
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _contentSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Start animations sequence
    _logoController.forward().then((_) {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _glowController.dispose();
    super.dispose();
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
              AppTheme.primaryMint.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 32 + MediaQuery.of(context).padding.left,
                    right: 32 + MediaQuery.of(context).padding.right,
                    bottom: MediaQuery.of(context).padding.bottom + 32,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        // Animated Logo
                        AnimatedBuilder(
                          animation: Listenable.merge([_logoController, _contentController, _glowController]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow effect
                                  Transform.scale(
                                    scale: _glowAnimation.value,
                                    child: Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryMint.withOpacity(0.3),
                                            blurRadius: 40 * _glowAnimation.value,
                                            spreadRadius: 8 * _glowAnimation.value,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Ripple effects
                                  Transform.scale(
                                    scale: 1 + (_rippleAnimation.value * 0.3),
                                    child: Opacity(
                                      opacity: (1 - _rippleAnimation.value) * 0.4,
                                      child: Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              AppTheme.primaryMint.withOpacity(0.3),
                                              AppTheme.primaryMint.withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 1 + (_rippleAnimation.value * 0.2),
                                    child: Opacity(
                                      opacity: (1 - _rippleAnimation.value) * 0.3,
                                      child: Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              AppTheme.primaryMint.withOpacity(0.4),
                                              AppTheme.primaryMint.withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Main logo circle with gradient
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          AppTheme.primaryMint.withOpacity(0.3),
                                          AppTheme.primaryMint.withOpacity(0.2),
                                        ],
                                        focal: Alignment(0.1, 0.1),
                                        center: Alignment(0.2, 0.2),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryMint.withOpacity(0.2),
                                          blurRadius: 20,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // White glow behind the icon
                                          Icon(
                                            Icons.eco,
                                            size: 65,
                                            color: Colors.white.withOpacity(0.9),
                                          ),
                                          // Gradient overlay on top
                                          ShaderMask(
                                            shaderCallback: (Rect bounds) {
                                              return LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white.withOpacity(0.95),
                                                  Colors.white.withOpacity(0.8),
                                                ],
                                              ).createShader(bounds);
                                            },
                                            child: Icon(
                                              Icons.eco,
                                              size: 65,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 60),
                        // Animated Content
                        AnimatedBuilder(
                          animation: _contentController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _contentSlideAnimation.value),
                              child: Opacity(
                                opacity: _contentFadeAnimation.value,
                                child: Column(
                                  children: [
                                    Text(
                                      'Welcome to Serenity',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        color: AppTheme.textDark,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Find your inner peace',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppTheme.textLight,
                                        fontSize: 18,
                                        letterSpacing: 0.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 60),
                                    // Animated Button
                                    Transform.scale(
                                      scale: _buttonScaleAnimation.value,
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryMint.withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(context, '/onboarding');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primaryMint,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 18,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'Begin Your Journey',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} 