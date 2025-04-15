import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'dart:math' as math;

class BiometricConnectScreen extends StatefulWidget {
  const BiometricConnectScreen({super.key});

  @override
  State<BiometricConnectScreen> createState() => _BiometricConnectScreenState();
}

class _BiometricConnectScreenState extends State<BiometricConnectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isConnecting = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startConnection() {
    setState(() {
      _isConnecting = true;
    });

    // Simulate connection process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isConnecting = false;
        _isConnected = true;
      });

      // Navigate to home screen after successful connection
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }

  Widget _buildPulsingHeart() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + math.sin(_controller.value * 2 * math.pi) * 0.1,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryMint.withOpacity(0.1),
            ),
            child: Icon(
              Icons.favorite,
              size: 60,
              color: AppTheme.primaryMint,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMint),
            strokeWidth: 8,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Connecting to Health Services',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This may take a moment...',
          style: TextStyle(
            color: AppTheme.textLight,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIndicator() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryMint.withOpacity(0.1),
          ),
          child: Icon(
            Icons.check_circle,
            size: 60,
            color: AppTheme.primaryMint,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Successfully Connected!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!_isConnecting && !_isConnected) ...[
                    _buildPulsingHeart(),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Connect Your Health Data',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'We use this data to provide personalized stress management recommendations and track your progress',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: _startConnection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryMint,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Connect Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else if (_isConnecting) ...[
                    _buildConnectingIndicator(),
                  ] else if (_isConnected) ...[
                    _buildSuccessIndicator(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryMint.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryMint,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 