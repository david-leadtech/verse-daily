# Verse Daily 📖

A beautiful, feature-rich iOS app for daily Bible reading, devotionals, and spiritual growth. Built with SwiftUI following Clean Architecture principles.

## Features

### 📚 Bible Module
- **66 Canonical Books**: Browse the complete Old and New Testament
- **Dynamic Chapter Selection**: Intuitive range-based chapter browser (1-10, 11-20, etc.)
- **Full Chapter Reading**: Read verses with proper formatting and spacing
- **Favorite Verses**: Save and organize your favorite verses
- **Multiple Bible Versions**: Support for different Bible translations (currently KJV)

### 🙏 Daily Devotionals
- **Verse of the Day**: Curated daily verse with reflection
- **Devotional Library**: Collection of categorized devotionals (Peace, Faith, etc.)
- **Quick Reads**: 3-5 minute devotionals for busy schedules
- **Interactive Cards**: Smooth animations and visual feedback

### 📝 Prayer & Journaling
- **Prayer Journal**: Document your prayers and spiritual journey
- **Persistent Storage**: All entries saved locally with SwiftData
- **Organized by Date**: Easy navigation through prayer history

### 📅 Liturgical Calendar
- **Church Calendar**: Display liturgical days and seasons
- **Color-coded Themes**: Visual representation of liturgical colors
- **Seasonal Context**: Understand the spiritual significance of each day

### ⚙️ User Preferences
- **Notification Settings**: Customize daily reminders
- **Bible Version Selection**: Choose your preferred translation
- **Theme Options**: Adapt UI to liturgical calendar colors
- **Premium Features**: Subscription management interface

## Technical Details

### Architecture
- **Clean Architecture**: Domain → Application → Presentation → Infrastructure layers
- **MVVM Pattern**: ViewModels for state management
- **Dependency Injection**: Service container for loose coupling
- **Protocol-based Design**: Repository pattern for data access

### Tech Stack
- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData (on-device database)
- **Async/Await**: Modern Swift concurrency
- **Design System**: Centralized component library
- **Local Packages**: Modular architecture with SPM

### Key Components
- **DesignSystem**: Reusable components, colors, typography, spacing
- **CoreServices**: Business logic (Liturgical calendar, etc.)
- **CoreModels**: Shared data models across features
- **CorePersistence**: Local data management
- **CoreUtils**: Shared utilities

## Project Structure

```
VerseDaily-iOS/
├── App/                          # App entry point & main navigation
├── Features/                      # Feature modules
│   ├── Bible/                    # Bible reading feature
│   ├── Devotional/               # Daily devotionals
│   ├── User/                     # User settings
│   ├── Monetization/             # Subscription management
│   ├── Liturgical/               # Liturgical calendar
│   └── Prayer/                   # Prayer journal
├── SharedKernel/                 # Cross-cutting concerns
├── Infrastructure/               # Data access & mocks
└── LocalPackages/                # Shared libraries
    ├── DesignSystem/
    ├── CoreServices/
    ├── CoreModels/
    ├── CorePersistence/
    └── CoreUtils/
```

## Getting Started

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `VerseDaily-iOS/VerseDaily.xcodeproj`
3. Build and run on simulator or device

### Build & Run
```bash
cd VerseDaily-iOS
xcodebuild build -project VerseDaily.xcodeproj -scheme VerseDaily
```

## Features Roadmap

### v1.0.0 (Current)
- ✅ Bible browsing with all 66 books
- ✅ Daily verse and devotionals
- ✅ Prayer journaling
- ✅ Liturgical calendar
- ✅ User settings
- ✅ Favorite verses (UI ready)

### v1.1.0 (Planned)
- 📋 Verse search and filtering
- 📋 Reading plans
- 📋 Streak tracking
- 📋 Offline mode improvements
- 📋 Share verses functionality

### v2.0.0 (Planned)
- 📋 Cloud sync
- 📋 Multiple Bible versions
- 📋 Community features
- 📋 Advanced analytics
- 📋 Meditation/Audio features

## Design System

### Colors
- **Primary**: Brown (#8B4513) - Spiritual, grounded
- **Accent**: Gold (#C5963A) - Warmth, highlights
- **Secondary**: Tan/Cream (#FDF8F0) - Clean, readable
- **Liturgical**: Dynamic colors based on church calendar

### Typography
- **Headlines**: Playfair Display (elegant, serif)
- **Body**: Inter (readable, modern)
- **Sizes**: Scalable from 12px to 32px

### Components
- Cards with gradients
- Badges for categorization
- Buttons with multiple states
- Input fields with validation
- Modal dialogs
- Data tables

## Contributing

This project follows these principles:
- **Clean Code**: Readable, maintainable, well-documented
- **Architecture**: Clear separation of concerns
- **Testing**: Unit tests for critical logic (in progress)
- **Performance**: Optimized for smooth scrolling and fast responses

## License

All rights reserved. Verse Daily © 2024-2026

## Contact & Support

For questions, suggestions, or issues:
- 📧 Email: [your-email]
- 🐛 Issues: GitHub Issues
- 💬 Discussion: GitHub Discussions

---

**Built with ❤️ and faith** | Made with SwiftUI & Clean Architecture
