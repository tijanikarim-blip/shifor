# Shifor - Driver Recruitment Platform

A Flutter mobile application for connecting drivers with companies. Drivers can create profiles, search for jobs, apply to positions, and communicate with employers.

## Features

- **Home Screen**: Welcome dashboard with availability status and driver matching
- **Jobs Screen**: Browse and search for driving jobs with filters
- **Applications Screen**: Track your job applications
- **Messages Screen**: Chat with companies
- **Profile Screen**: Manage your driver profile

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Android SDK / Xcode (for mobile development)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── mock_data.dart
├── screens/
│   ├── home_screen.dart
│   ├── jobs_screen.dart
│   ├── applications_screen.dart
│   ├── messages_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── driver_card.dart
│   ├── job_card.dart
│   ├── application_card.dart
│   ├── company_card.dart
│   ├── message_item.dart
│   ├── filter_bar.dart
│   ├── rating_stars.dart
│   ├── availability_toggle.dart
│   ├── skeleton_loader.dart
│   └── empty_state.dart
└── main.dart
```

## Push to GitHub

1. Initialize git:
   ```bash
   git init
   ```

2. Add files:
   ```bash
   git add .
   ```

3. Commit:
   ```bash
   git commit -m "Initial commit - Shifor driver recruitment app"
   ```

4. Create repository on GitHub, then:
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/shifor.git
   git branch -M main
   git push -u origin main
   ```

## Tech Stack

- Flutter 3.0+
- Dart
- Cached Network Image (for image caching)
- Material Design 3