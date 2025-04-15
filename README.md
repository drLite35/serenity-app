# Serenity - Mindfulness & Stress Management App

Serenity is a Flutter-based mobile application designed to help users manage stress and improve their mental well-being through various mindfulness exercises and stress tracking tools.

## Features

### Core Functionality
- **PSS (Perceived Stress Scale) Assessment**: Track and monitor stress levels using standardized questionnaires
- **Biometric Integration**: Connect with health services to monitor heart rate and other vital signs
- **Progress Tracking**: Visualize stress levels and exercise completion over time

### Mindfulness Exercises
- **Deep Breathing**: Guided breathing exercises with animations and audio
- **Guided Meditation**: Audio-guided meditation sessions
- **Progressive Muscle Relaxation**: Step-by-step body relaxation exercises
- **Mindful Coloring**: Interactive coloring activities for stress relief
- **Gratitude Journal**: Daily gratitude practice
- **Grounding Exercises**: Present-moment awareness techniques

### Additional Features
- **Personalized Dashboard**: Track progress and access quick exercise shortcuts
- **Exercise Feedback**: Rate and review completed exercises
- **Customizable Notifications**: Set reminders for mindfulness practice
- **Emergency Contact**: Quick access to support contacts
- **Statistics**: Detailed views of stress levels and exercise completion

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- iOS/Android development environment

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/drLite35/serenity-app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd serenity-app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Configuration
- Enable necessary permissions in iOS (Info.plist) and Android (AndroidManifest.xml)
- Configure notification settings
- Set up health data access permissions

## Technical Stack
- **Framework**: Flutter
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Health Data**: Health Connect API
- **Notifications**: flutter_local_notifications
- **Audio**: audioplayers
- **Charts**: fl_chart

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Font used: Poppins
- Icons from Material Design
- Sound effects from [source pending]
