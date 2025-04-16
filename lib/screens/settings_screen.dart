import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _afternoonTime = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 20, minute: 0);
  String _emergencyName = '';
  String _emergencyContact = '';
  late SharedPreferences _prefs;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? false;
      _morningTime = _stringToTime(_prefs.getString('morning_time') ?? '08:00');
      _afternoonTime = _stringToTime(_prefs.getString('afternoon_time') ?? '14:00');
      _eveningTime = _stringToTime(_prefs.getString('evening_time') ?? '20:00');
      _emergencyName = _prefs.getString('emergency_name') ?? '';
      _emergencyContact = _prefs.getString('emergency_contact') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('notifications_enabled', _notificationsEnabled);
    await _prefs.setString('morning_time', _timeToString(_morningTime));
    await _prefs.setString('afternoon_time', _timeToString(_afternoonTime));
    await _prefs.setString('evening_time', _timeToString(_eveningTime));
    await _prefs.setString('emergency_name', _emergencyName);
    await _prefs.setString('emergency_contact', _emergencyContact);
    
    // Update notification scheduling
    if (_notificationsEnabled) {
      await _notificationService.cancelAllNotifications();
      await _notificationService.scheduleDailyNotification(
        _morningTime,
        1,
        'Morning Mindfulness',
      );
      await _notificationService.scheduleDailyNotification(
        _afternoonTime,
        2,
        'Afternoon Break',
      );
      await _notificationService.scheduleDailyNotification(
        _eveningTime,
        3,
        'Evening Reflection',
      );
    } else {
      await _notificationService.cancelAllNotifications();
    }
  }

  String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay _stringToTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay initialTime) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _showEmergencyContactDialog() async {
    final nameController = TextEditingController(text: _emergencyName);
    final contactController = TextEditingController(text: _emergencyContact);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter contact name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _emergencyName = nameController.text;
                _emergencyContact = contactController.text;
                _saveSettings();
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryMint,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Notifications'),
              const SizedBox(height: 8),
              _buildNotificationCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Emergency Contact'),
              const SizedBox(height: 8),
              _buildEmergencyContactCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'App Preferences'),
              const SizedBox(height: 8),
              _buildPreferencesCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'About'),
              const SizedBox(height: 8),
              _buildAboutCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppTheme.textDark,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders for mindfulness exercises'),
            value: _notificationsEnabled,
            activeColor: AppTheme.primaryMint,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                _saveSettings();
              });
            },
          ),
          if (_notificationsEnabled) ...[
            const Divider(height: 1),
            _buildNotificationTimePicker(
              'Morning Reminder',
              _morningTime,
              (time) => _morningTime = time,
              Icons.wb_sunny,
            ),
            const Divider(height: 1),
            _buildNotificationTimePicker(
              'Afternoon Reminder',
              _afternoonTime,
              (time) => _afternoonTime = time,
              Icons.sunny,
            ),
            const Divider(height: 1),
            _buildNotificationTimePicker(
              'Evening Reminder',
              _eveningTime,
              (time) => _eveningTime = time,
              Icons.nightlight_round,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationTimePicker(
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onTimeChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryMint),
      title: Text(label),
      subtitle: Text('${time.format(context)}'),
      trailing: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: () async {
          final TimeOfDay? newTime = await _selectTime(context, time);
          if (newTime != null) {
            setState(() {
              onTimeChanged(newTime);
              _saveSettings();
            });
          }
        },
      ),
    );
  }

  Widget _buildEmergencyContactCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.emergencyRed.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.emergency,
            color: AppTheme.emergencyRed,
          ),
        ),
        title: Text(_emergencyName.isEmpty ? 'Add Emergency Contact' : _emergencyName),
        subtitle: Text(_emergencyContact.isEmpty ? 'Tap to add contact details' : _emergencyContact),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: _showEmergencyContactDialog,
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode, color: AppTheme.primaryMint),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: false,
              activeColor: AppTheme.primaryMint,
              onChanged: (value) {
                // TODO: Implement dark mode
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.language, color: AppTheme.primaryMint),
            title: const Text('Language'),
            trailing: const Text('English'),
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: AppTheme.primaryMint),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/data-privacy');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info, color: AppTheme.primaryMint),
            title: const Text('About Serenity'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Show about dialog
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.star, color: AppTheme.primaryMint),
            title: const Text('Rate the App'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Open app store rating
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.feedback, color: AppTheme.primaryMint),
            title: const Text('Send Feedback'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Open feedback form
            },
          ),
        ],
      ),
    );
  }
}