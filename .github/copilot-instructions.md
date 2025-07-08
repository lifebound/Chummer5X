# Copilot Instructions for Chummer5X

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
This is a Flutter application for viewing and interacting with Shadowrun character files from the Chummer character creation application. The app parses XML files and presents character data in a modern, platform-agnostic interface.

## Key Technologies
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **XML Parsing**: For reading Chummer character files
- **Material Design**: UI/UX following Material Design principles

## Code Style Guidelines
- Follow Dart and Flutter best practices
- Use meaningful variable and function names
- Implement proper error handling for XML parsing
- Structure code with clear separation of concerns (models, views, services)
- Use Flutter's state management patterns (Provider, Riverpod, or Bloc)

## Project Structure
- `/lib/models/` - Data models for Shadowrun character data
- `/lib/services/` - XML parsing and file handling services
- `/lib/screens/` - UI screens for different character views
- `/lib/widgets/` - Reusable UI components
- `/lib/utils/` - Utility functions and constants

## Specific Considerations
- Handle large XML files efficiently
- Ensure cross-platform compatibility (mobile, desktop, web)
- Implement responsive design for different screen sizes
- Consider offline functionality for character viewing
- Follow Shadowrun game mechanics and terminology accurately
