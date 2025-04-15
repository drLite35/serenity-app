import 'package:flutter/material.dart';
import '../services/exercise_feedback_service.dart';
import '../utils/theme.dart';
import '../models/exercise_feedback.dart';

class ExerciseFeedbackDialog extends StatefulWidget {
  final String exerciseName;
  final ExerciseFeedbackService feedbackService;

  const ExerciseFeedbackDialog({
    Key? key,
    required this.exerciseName,
    required this.feedbackService,
  }) : super(key: key);

  @override
  State<ExerciseFeedbackDialog> createState() => _ExerciseFeedbackDialogState();
}

class _ExerciseFeedbackDialogState extends State<ExerciseFeedbackDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _rating = 0;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildRatingButton(int value) {
    final bool isSelected = _rating == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _rating = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryMint : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryMint : AppTheme.accentGray.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryMint.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          value.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'How was your experience?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.exerciseName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryMint,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Rate your experience (1-5):',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => _buildRatingButton(index + 1),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any notes or comments (optional)',
                  hintStyle: TextStyle(
                    color: AppTheme.textLight.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppTheme.accentGray.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: AppTheme.textLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _rating == 0
                ? null
                : () async {
                    await widget.feedbackService.saveFeedback(
                      ExerciseFeedback(
                        exerciseName: widget.exerciseName,
                        rating: _rating,
                        timestamp: DateTime.now(),
                        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                      ),
                    );
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryMint,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
} 