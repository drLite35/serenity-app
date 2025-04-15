import 'package:flutter/material.dart';
import '../utils/theme.dart';

class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({super.key});

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data & Privacy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryMint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppTheme.primaryMint,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Your privacy and data security are our top priorities',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSection(
                context,
                'Why We Collect Data',
                'We collect biometric and stress data to help you understand your stress patterns and provide personalized recommendations for managing your well-being. This data helps us tailor exercises and interventions specifically for you.',
              ),
              _buildSection(
                context,
                'How Your Data Helps You',
                'Your data enables us to:\n\n• Track your stress levels over time\n• Identify patterns and triggers\n• Recommend the most effective exercises\n• Measure your progress\n• Send timely, relevant notifications',
              ),
              _buildSection(
                context,
                'Data Security',
                'All your data is encrypted and stored securely on your device. We never share your personal information with third parties. Your biometric data is processed locally and is not transmitted to external servers.',
              ),
              _buildSection(
                context,
                'Your Control',
                'You have complete control over your data. You can:\n\n• View all collected data\n• Export your data\n• Delete your data at any time\n• Adjust notification preferences\n• Opt out of data collection',
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/privacy'),
                  icon: const Icon(Icons.privacy_tip_outlined),
                  label: const Text('View Full Privacy Policy'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryMint,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 