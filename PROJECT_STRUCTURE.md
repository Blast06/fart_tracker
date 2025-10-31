# Fart Hero - Project Structure

## Overview

This document provides a complete overview of the project's architecture and file organization.

## Directory Structure

```
fart_hero/
├── lib/
│   ├── config/
│   │   └── supabase_config.dart          # Supabase configuration
│   │
│   ├── l10n/
│   │   ├── l10n.yaml                     # Localization config
│   │   ├── app_en.arb                    # English translations
│   │   └── app_es.arb                    # Spanish translations
│   │
│   ├── models/
│   │   ├── badge.dart                    # Badge data model
│   │   ├── fart_log.dart                 # Fart log entry model
│   │   └── weekly_stats.dart             # Weekly statistics model
│   │
│   ├── providers/
│   │   ├── fart_provider.dart            # Main app state management
│   │   └── locale_provider.dart          # Language selection state
│   │
│   ├── screens/
│   │   └── home_screen.dart              # Main application screen
│   │
│   ├── services/
│   │   ├── fart_service.dart             # Abstract service interface
│   │   ├── mock_fart_service.dart        # Mock implementation (default)
│   │   └── supabase_fart_service.dart    # Supabase implementation
│   │
│   ├── widgets/
│   │   ├── badge_card.dart               # Achievement badge widget
│   │   ├── gradient_card.dart            # Styled card container
│   │   └── weekly_chart.dart             # Bar chart for weekly stats
│   │
│   └── main.dart                         # App entry point
│
├── supabase/
│   └── migrations/
│       └── [timestamp]_create_farts_table.sql  # Database schema
│
├── .env.example                          # Environment variables template
├── .gitignore                            # Git ignore rules
├── analysis_options.yaml                 # Dart linter configuration
├── pubspec.yaml                          # Flutter dependencies
├── README.md                             # Main documentation
├── API_IMPLEMENTATION_GUIDE.md           # Custom API guide
└── PROJECT_STRUCTURE.md                  # This file
```

## Architecture Layers

### 1. Models Layer (`lib/models/`)

Data classes representing the core entities:

- **FartLog**: Individual fart log entry
  - id, userId, loggedAt, isSilent, createdAt

- **WeeklyStats**: Aggregated weekly statistics
  - dailyCounts (7-day array), totalWeek, todayCount

- **Badge**: Achievement badge information
  - emoji, titleKey, descriptionKey, isUnlocked

### 2. Services Layer (`lib/services/`)

Business logic and data access:

- **FartService** (Abstract Interface)
  - Defines contract: initialize(), logFart(), getWeeklyStats(), resetDemo()

- **MockFartService** (Implementation)
  - In-memory mock data
  - No backend required
  - Perfect for testing/demo

- **SupabaseFartService** (Implementation)
  - Real database integration
  - User authentication
  - Row Level Security

### 3. Providers Layer (`lib/providers/`)

State management using Provider pattern:

- **FartProvider**
  - Manages fart logs and statistics
  - Handles loading states
  - Coordinates with service layer
  - Manages silent mode toggle

- **LocaleProvider**
  - Manages language selection
  - Persists user preference
  - Triggers UI updates on language change

### 4. Screens Layer (`lib/screens/`)

Full-page views:

- **HomeScreen**
  - Main app interface
  - Displays all sections
  - Handles user interactions

### 5. Widgets Layer (`lib/widgets/`)

Reusable UI components:

- **GradientCard**: Styled container with shadow and backdrop blur
- **WeeklyChart**: Interactive bar chart using fl_chart
- **BadgeCard**: Achievement badge display

### 6. Localization Layer (`lib/l10n/`)

Internationalization support:

- ARB files for each language (en, es)
- Automatic code generation
- Easy to add new languages

## Data Flow

```
User Interaction
      ↓
  HomeScreen
      ↓
  FartProvider (State Management)
      ↓
  FartService (Interface)
      ↓
  ┌─────────────────┬──────────────────────┐
  ↓                 ↓                      ↓
MockFartService  SupabaseFartService  YourCustomService
  ↓                 ↓                      ↓
In-Memory Data   Supabase DB         Your API
```

## Key Features by File

### Main Screen Features

**home_screen.dart** provides:
- Header with language selector
- Today's count display
- Weekly goal progress bar
- Log fart button
- Weekly breakdown chart
- Achievement badges grid
- Silent mode toggle
- Reset demo button

### Service Implementations

**mock_fart_service.dart**:
- ✅ Works immediately, no setup
- ✅ Pre-populated demo data
- ✅ Perfect for development
- ⚠️ Data resets on app restart

**supabase_fart_service.dart**:
- ✅ Real database persistence
- ✅ User authentication
- ✅ Secure with RLS policies
- ⚠️ Requires Supabase setup

### State Management

**fart_provider.dart** manages:
- Current statistics (today, week)
- Loading states
- Error handling
- Silent mode preference
- Demo reset functionality

## Database Schema

```sql
farts table:
├── id (uuid, PK)
├── user_id (uuid, FK → auth.users)
├── logged_at (timestamptz)
├── is_silent (boolean)
└── created_at (timestamptz)

Indexes:
- idx_farts_user_id
- idx_farts_logged_at

Security:
- RLS enabled
- Policies for SELECT, INSERT, DELETE
```

## Dependencies

### Core Flutter
- `flutter` - Framework
- `flutter_localizations` - i18n support

### State Management
- `provider` - State management

### Database & Backend
- `supabase_flutter` - Supabase client

### UI & Charts
- `fl_chart` - Beautiful charts

### Storage
- `shared_preferences` - Local persistence

### Utilities
- `intl` - Internationalization

## Configuration Files

- **pubspec.yaml**: Dependencies and assets
- **analysis_options.yaml**: Linting rules
- **.gitignore**: Files to exclude from git
- **l10n.yaml**: Localization generation config
- **.env.example**: Environment variables template

## Adding New Features

### To add a new language:
1. Create `lib/l10n/app_[code].arb`
2. Add translations
3. Update `supportedLocales` in main.dart

### To add a new API service:
1. Implement `FartService` interface
2. Add your custom logic
3. Update service instantiation in main.dart
4. See API_IMPLEMENTATION_GUIDE.md

### To add new statistics:
1. Update `WeeklyStats` model
2. Modify service implementations
3. Update UI in HomeScreen

### To add new badges:
1. Update badges list in `FartProvider`
2. Add translations to ARB files
3. UI will automatically update

## Testing Strategy

### Unit Tests
- Test models (JSON serialization)
- Test service methods
- Test provider logic

### Widget Tests
- Test individual widgets
- Test user interactions
- Test state updates

### Integration Tests
- Test complete user flows
- Test with real API calls
- Test language switching

## Performance Considerations

- **Lazy Loading**: Charts only render when visible
- **State Optimization**: Provider only rebuilds affected widgets
- **Caching**: Preferences cached locally
- **Mock Service**: No network latency during development

## Security

- Environment variables for sensitive data
- Row Level Security in Supabase
- No hardcoded credentials
- Secure token storage (when using real auth)
