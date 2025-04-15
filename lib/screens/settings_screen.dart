import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Here you would also update notification scheduling
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
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                    _saveSettings();
                  });
                },
              ),
            ),
            if (_notificationsEnabled) ...[
              const SizedBox(height: 16),
              _buildNotificationTimePicker(
                'Morning Reminder',
                _morningTime,
                (time) => _morningTime = time,
              ),
              _buildNotificationTimePicker(
                'Afternoon Reminder',
                _afternoonTime,
                (time) => _afternoonTime = time,
              ),
              _buildNotificationTimePicker(
                'Evening Reminder',
                _eveningTime,
                (time) => _eveningTime = time,
              ),
            ],
            const SizedBox(height: 16),
            _buildEmergencyContactCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTimePicker(
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onTimeChanged,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
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
      ),
    );
  }

  Widget _buildEmergencyContactCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: const Text('Emergency Contact'),
        subtitle: _emergencyName.isNotEmpty
            ? Text('$_emergencyName\n$_emergencyContact')
            : const Text('No emergency contact set'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _showEmergencyContactDialog,
        ),
      ),
    );
  }
}