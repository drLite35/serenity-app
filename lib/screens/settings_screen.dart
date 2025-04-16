import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
      final hour = prefs.getInt('notification_hour') ?? 9;
      final minute = prefs.getInt('notification_minute') ?? 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setInt('notification_hour', _selectedTime.hour);
    await prefs.setInt('notification_minute', _selectedTime.minute);

    if (_notificationsEnabled) {
      await _notificationService.scheduleDailyNotification(
        _selectedTime,
        1,
        'Daily Check-in',
      );
    } else {
      await _notificationService.cancelAllNotifications();
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? AppTheme.primaryMint.withOpacity(0.12)
                    : Colors.transparent),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? AppTheme.primaryMint
                    : AppTheme.textLight),
              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? AppTheme.primaryMint.withOpacity(0.12)
                    : Colors.transparent),
              hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? AppTheme.primaryMint
                    : AppTheme.textLight),
            ),
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryMint,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      await _saveSettings();
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildSection(
                      'Notifications',
                      [
                        _buildSettingTile(
                          'Daily Reminders',
                          'Get gentle reminders to check in',
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) async {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                              await _saveSettings();
                            },
                            activeColor: AppTheme.primaryMint,
                            activeTrackColor: AppTheme.primaryMint.withOpacity(0.3),
                          ),
                        ),
                        if (_notificationsEnabled)
                          _buildSettingTile(
                            'Reminder Time',
                            'Set your preferred time',
                            onTap: _selectTime,
                            trailing: Text(
                              _selectedTime.format(context),
                              style: TextStyle(
                                color: AppTheme.primaryMint,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'App Settings',
                      [
                        _buildSettingTile(
                          'Privacy Policy',
                          'Read our privacy policy',
                          onTap: () {
                            Navigator.pushNamed(context, '/data-privacy');
                          },
                        ),
                        _buildSettingTile(
                          'Terms of Service',
                          'View terms of service',
                          onTap: () {
                            // Navigate to terms of service
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryMint.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textLight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}