# Chummer5X

A modern, platform-agnostic Flutter application for viewing and interacting with Shadowrun character files from the Chummer character creation application.

## Features

- 📱 **Cross-Platform**: Works on mobile, desktop, and web
- 📄 **XML Parsing**: Reads Chummer XML character files with comprehensive data extraction
- 🎨 **Modern UI**: Clean, intuitive Material Design interface
- 📊 **Enhanced Character Display**: 
  - Comprehensive attribute system with adept power modifiers
  - Skills with skill groups and specializations
  - Spells, spirits, and complex forms for magical characters
  - Adept powers with ratings and effects
  - Gear and equipment with categories and ratings
  - Limit calculations and modifiers
- 🌙 **Dark Mode**: Automatic light/dark theme support
- 💾 **File Handling**: Easy file selection and caching
- 🔄 **Backwards Compatibility**: Supports both basic and enhanced parsing modes

## Character Data Supported

### Basic Information
- Character name, alias, metatype
- Physical characteristics (age, sex, height, weight)
- Karma, street cred, notoriety, public awareness

### Attributes & Skills
- All 8 primary attributes (Body, Agility, Reaction, Strength, Charisma, Intuition, Logic, Willpower)
- Special attributes (Edge, Magic, Resonance)
- Comprehensive skills system with skill groups
- Adept power modifications to attributes and skills

### Magic & Resonance
- Spells with categories and grades
- Spirits and their bindings
- Complex forms for technomancers
- Adept powers with ratings and specializations

### Equipment & Gear
- Weapons, armor, and general gear
- Equipment ratings and categories
- Equipped vs. carried status
- Quantity tracking

### Derived Statistics
- Physical, Mental, and Social limits
- Initiative and other derived attributes
- Condition monitors (Physical and Stun damage)

## Getting Started

### Prerequisites

- Flutter SDK (3.5.4 or later)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/chummer5x.git
cd chummer5x
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Usage

1. Launch the application
2. Tap "Load Character File" to select a Chummer XML file
3. View your Shadowrun character's details, attributes, and stats
4. Navigate through different character information screens

## Supported File Formats

- `.xml` - Standard Chummer character files
- `.chum5` - Chummer 5th Edition files

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── models/
│   └── shadowrun_character.dart       # Enhanced character data model with attributes, skills, magic, gear
├── screens/
│   ├── home_screen.dart               # Main application screen
│   ├── character_detail_screen.dart   # Character overview and navigation
│   └── skills_screen.dart             # Skills, spells, powers, and gear display
├── services/
│   ├── chumer_xml_service.dart        # Basic XML parsing (backwards compatible)
│   ├── enhanced_chumer_xml_service.dart # Comprehensive XML parsing
│   └── file_service.dart              # File handling operations
└── widgets/
    ├── character_info_card.dart       # Character information widget
    └── attributes_card.dart           # Enhanced attributes display widget
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Chummer team for the original character creation tool
- Shadowrun community for support and feedback
- Flutter team for the amazing framework
