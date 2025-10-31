# Fart Hero 💨

A Flutter app to log your daily farts with stats, achievements, and internationalization support.

## Features

- 📊 Daily and weekly fart tracking
- 📈 Beautiful weekly breakdown chart
- 🏅 Achievement badges system
- 🌍 Multi-language support (English & Spanish)
- 🤫 Stealth mode toggle
- 🎨 Beautiful gradient UI with smooth animations
- 💾 Mock data for testing and demo purposes
- 🔌 Ready-to-use Supabase integration

## Project Structure

```
lib/
├── config/          # Configuration files (Supabase config)
├── l10n/            # Internationalization files
├── models/          # Data models (FartLog, WeeklyStats, Badge)
├── providers/       # State management (Provider pattern)
├── screens/         # App screens
├── services/        # API service layer
│   ├── fart_service.dart           # Abstract service interface
│   ├── mock_fart_service.dart      # Mock implementation for testing
│   └── supabase_fart_service.dart  # Supabase implementation
└── widgets/         # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

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

## Using Mock Data (Default)

The app is configured to use `MockFartService` by default, which provides:
- Pre-populated weekly data
- Simulated API delays
- No backend required
- Perfect for testing and demo

## Switching to Supabase

To use the real Supabase backend:

1. Create a `.env` file based on `.env.example`:
```bash
cp .env.example .env
```

2. Add your Supabase credentials to `.env`

3. Update `lib/main.dart` to use `SupabaseFartService`:

```dart
// Replace MockFartService with SupabaseFartService
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

  // Use SupabaseFartService instead of MockFartService
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

## Database Schema

The Supabase database includes:

### `farts` table
- `id` (uuid) - Primary key
- `user_id` (uuid) - Foreign key to auth.users
- `logged_at` (timestamptz) - When the fart was logged
- `is_silent` (boolean) - Silent mode flag
- `created_at` (timestamptz) - Record creation timestamp

With Row Level Security (RLS) policies for authenticated users.

## Internationalization

Currently supported languages:
- 🇺🇸 English
- 🇪🇸 Spanish (Español)

To add a new language:
1. Create `lib/l10n/app_[locale].arb`
2. Add translations
3. Update `supportedLocales` in `main.dart`

## Architecture

The app follows a clean architecture pattern:

- **Models**: Data structures
- **Services**: Abstract interface + implementations (Mock & Supabase)
- **Providers**: State management using Provider package
- **Screens**: UI pages
- **Widgets**: Reusable components

This makes it easy to:
- Switch between mock and real API
- Test features independently
- Add new data sources
- Maintain clean separation of concerns

## Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```
