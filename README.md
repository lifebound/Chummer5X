# Chummer5X

A modern, platform-agnostic Flutter application for viewing and interacting with Shadowrun character files from the Chummer character creation application.

## Features

- 📱 **Cross-Platform**: Works on mobile, desktop, and web
- 📄 **XML Parsing**: Reads Chummer XML character files
- 🎨 **Modern UI**: Clean, intuitive Material Design interface
- 📊 **Character Display**: View attributes, skills, and character information
- 🌙 **Dark Mode**: Automatic light/dark theme support
- 💾 **File Handling**: Easy file selection and caching

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
├── main.dart                 # Application entry point
├── models/
│   └── shadowrun_character.dart  # Character data model
├── screens/
│   ├── home_screen.dart      # Main application screen
│   └── character_detail_screen.dart  # Character details view
├── services/
│   ├── chumer_xml_service.dart    # XML parsing logic
│   └── file_service.dart     # File handling operations
└── widgets/
    ├── character_info_card.dart   # Character info widget
    └── attributes_card.dart       # Attributes display widget
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
