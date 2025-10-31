# Quick Start Guide

Get Fart Hero running in minutes!

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / Xcode (for mobile) or Chrome (for web)

## Installation

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
# For mobile (Android/iOS)
flutter run

# For web
flutter run -d chrome

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

That's it! The app is now running with mock data.

## Features You Can Try

1. **Log a Fart**: Click the green "+ Log New Fart" button
2. **View Stats**: Check the weekly breakdown chart
3. **Switch Language**: Use the language dropdown (English/Español)
4. **Toggle Stealth Mode**: Enable/disable in Quick Settings
5. **Reset Demo**: Click "Reset demo" to clear all mock data

## Current Setup

The app is configured to use **MockFartService** which:
- Provides instant results (no network calls)
- Pre-loads demo data (31 farts across the week)
- Doesn't require any backend setup
- Perfect for testing and demonstration

## Next Steps

### Option 1: Keep Using Mock Data

No action needed! The app works perfectly with mock data for:
- Development
- Testing
- Demos
- UI/UX iterations

### Option 2: Connect to Supabase

To use real data persistence:

1. **Get Supabase Credentials**
   - The Supabase database is already set up
   - Check your `.env` file for credentials

2. **Update main.dart**

Replace the mock service with Supabase service:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'services/supabase_fart_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  final localeProvider = LocaleProvider();
  await localeProvider.initialize();

  // Use Supabase service instead of mock
  final fartService = SupabaseFartService(Supabase.instance.client);
  final fartProvider = FartProvider(fartService);
  await fartProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: fartProvider),
      ],
      child: const MyApp(),
    ),
  );
}
```

3. **Restart the app**

```bash
flutter run
```

### Option 3: Implement Your Own API

See **API_IMPLEMENTATION_GUIDE.md** for detailed instructions on:
- Creating a custom service
- REST API implementation
- GraphQL implementation
- Testing your implementation

## Project Structure

```
lib/
├── main.dart              # App entry point (change service here)
├── models/                # Data models
├── services/              # API implementations
│   ├── mock_fart_service.dart        # Currently active
│   └── supabase_fart_service.dart    # Ready to use
├── providers/             # State management
├── screens/               # App screens
└── widgets/               # Reusable components
```

## Common Commands

```bash
# Run the app
flutter run

# Run with hot reload
# (saves state while you code)
flutter run --hot

# Build for production
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web

# Clean build cache
flutter clean
flutter pub get

# Check for issues
flutter doctor

# Run tests
flutter test

# Format code
flutter format .
```

## Troubleshooting

### "Package not found"
```bash
flutter pub get
flutter pub upgrade
```

### "SDK version mismatch"
Check your Flutter version:
```bash
flutter --version
flutter upgrade
```

### "Build failed"
Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

### "Supabase connection failed"
1. Check your `.env` file has correct credentials
2. Verify Supabase project is active
3. Check internet connection

### Charts not displaying
- Ensure `fl_chart` is installed: `flutter pub get`
- Check console for errors
- Try hot restart: press 'R' in terminal

## Development Tips

### Hot Reload
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debugging
```dart
// Add print statements
print('Today count: ${stats.todayCount}');

// Use debugger
debugger();
```

### Viewing Logs
```bash
# View all logs
flutter logs

# Filter by level
flutter logs | grep "ERROR"
```

### State Changes
The app uses Provider, so state changes automatically trigger UI updates. No manual refresh needed!

## What's Included

✅ Complete UI matching the original design
✅ Gradient background
✅ Interactive weekly chart
✅ Language switching (English/Spanish)
✅ Achievement badges
✅ Silent mode toggle
✅ Mock data service (active)
✅ Supabase integration (ready)
✅ Database schema with RLS
✅ Custom API guide

## Learn More

- **README.md** - Full project documentation
- **API_IMPLEMENTATION_GUIDE.md** - Custom API setup
- **PROJECT_STRUCTURE.md** - Architecture overview

## Support

If you encounter issues:
1. Check Flutter version: `flutter doctor`
2. Clean project: `flutter clean && flutter pub get`
3. Review error messages in console
4. Check the documentation files

## License

This project is open source and available for personal use.

---

Happy farting! 💨
