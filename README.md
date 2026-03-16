# Jenosize Loyalty App

A Flutter mobile application prototype for Jenosize's AI-powered loyalty platform, built as part of a technical assignment.

---

## Features

### 1. 🏠 Home Screen — Campaign List
- Displays **4 dummy loyalty campaigns** with image, title, description, and a "Join Now" CTA button
- Campaign search bar to filter campaigns by title or description
- Joining a campaign removes it from the list, adds **+50 pts** to the user's balance, and logs a transaction
- Pull-to-refresh support

### 2. 🥇 Membership Screen
- Tap "Join Membership Now" to simulate joining a membership
- Membership state is **persisted via SharedPreferences** so it survives app restarts
- Upon returning as a member, a personalized welcome message and Gold Member card are displayed

### 3. 👥 Refer-a-Friend Flow
- Displays a unique referral code (e.g. `JEN0123`)
- Users can **copy** the code to clipboard or **share** it via the native system share sheet (`share_plus`)
- Step-by-step guide showing how referrals work

### 4. 🏆 Points Tracker Screen
- Shows current **available balance** in a gradient card
- Displays a **transaction history list** (e.g. "Joined campaign: +50 pts", "Referral: +100 pts")
- Points balance and transaction history are **persisted via SharedPreferences**
- Tap **"See All"** to open the full Transaction History screen with sort & date filters

### 5. 📜 Transaction History Screen *(bonus)*
- Full-page screen with all transactions
- Filter options: **Newest, Oldest, High Points, Low Points**
- **Date range picker** to filter by specific date window

---

## Architecture

The project follows **clean architecture** principles with clear separation of layers:

```
lib/src/
├── domain/          # Pure data models (Campaign, UserProfile, PointTransaction)
├── data/            # Repository (MockLoyaltyRepository) + Riverpod Providers
├── features/        # Feature-first modular structure
│   ├── campaigns/   # Home screen & campaign card widget
│   ├── membership/  # Membership join & display screen
│   ├── points/      # Points balance & transaction history screen
│   ├── referral/    # Refer-a-friend screen
│   └── transactions/# Full transaction history with filters
├── routing/         # GoRouter navigation
├── theme/           # App theme & typography
└── widgets/         # Shared widgets
```

---

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter / Dart |
| State Management | **Riverpod** (`flutter_riverpod`) |
| Navigation | **GoRouter** |
| Local Storage | **SharedPreferences** |
| Icons | `flutter_phosphor_icons` |
| Fonts | `google_fonts` |
| Sharing | `share_plus` |
| Date Formatting | `intl` |

---

## State Management

**Riverpod** is used throughout the app with:
- `StateNotifierProvider` for `UserProfileNotifier`, `TransactionsNotifier`, `JoinedCampaignsNotifier`
- `FutureProvider` for the campaigns list
- `StateProvider` for the search query state
- `SharedPreferences` is injected via a top-level provider and overridden at app startup

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android Studio or VS Code with Flutter plugin

### Run the app

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

---

## Mock Data

All data is mocked locally via `MockLoyaltyRepository`:
- **4 campaigns** with Unsplash images, tags, and descriptions
- **Initial transactions**: Referral (+100 pts), Joined Campaign (+50 pts), Daily Check-in (+10 pts)
- **User profile**: Alex Thompson, 1,250 initial points, referral code `JEN0123`

No real backend or Firebase is used — all persistence is handled by `SharedPreferences`.