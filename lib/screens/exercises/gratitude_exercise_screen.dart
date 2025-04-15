import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GratitudeExerciseScreen extends StatefulWidget {
  const GratitudeExerciseScreen({super.key});

  @override
  State<GratitudeExerciseScreen> createState() => _GratitudeExerciseScreenState();
}

class _GratitudeExerciseScreenState extends State<GratitudeExerciseScreen> {
  final List<TextEditingController> _controllers = List.generate(3, (_) => TextEditingController());
  final List<String> _prompts = [
    'What made you smile today?',
    'What are you thankful for right now?',
    'What positive experience happened recently?',
  ];
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _saveEntries() {
    // TODO: Implement saving entries to local storage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Journal'),
        backgroundColor: AppTheme.primaryMint,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Gratitude Prompts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _prompts[index],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controllers[index],
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write your thoughts here...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.primaryMint.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.primaryMint,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 32),
              SwitchListTile(
                title: const Text('Daily Reminder'),
                subtitle: Text(
                  _reminderEnabled
                      ? 'Reminder set for ${_reminderTime.format(context)}'
                      : 'Get reminded to practice gratitude daily',
                ),
                value: _reminderEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _reminderEnabled = value;
                  });
                },
                activeColor: AppTheme.primaryMint,
              ),
              if (_reminderEnabled)
                ListTile(
                  title: const Text('Reminder Time'),
                  trailing: TextButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(_reminderTime.format(context)),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEntries,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryMint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Entries',
                    style: TextStyle(
                      fontSize: 18,
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