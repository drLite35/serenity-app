import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryMint.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.primaryMint,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.person_outline, color: AppTheme.primaryMint),
                title: const Text('Name'),
                subtitle: const Text('John Doe'),
              ),
              ListTile(
                leading: Icon(Icons.email_outlined, color: AppTheme.primaryMint),
                title: const Text('Email'),
                subtitle: const Text('john.doe@example.com'),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: AppTheme.primaryMint),
                title: const Text('Member Since'),
                subtitle: const Text('January 2024'),
              ),
              const SizedBox(height: 24),
              Text(
                'Progress',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProgressItem(
                        context,
                        'Exercises Completed',
                        '12',
                        Icons.check_circle_outline,
                      ),
                      const Divider(),
                      _buildProgressItem(
                        context,
                        'Meditation Minutes',
                        '120',
                        Icons.timer_outlined,
                      ),
                      const Divider(),
                      _buildProgressItem(
                        context,
                        'Current Streak',
                        '5 days',
                        Icons.local_fire_department_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem(BuildContext context, String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryMint),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textDark,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryMint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 