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

## Development Workflow
### Git Branch Management
- **New Feature = New Branch**: Create a feature branch for each new feature (`git checkout -b feature/feature-name`)
- **Regular Commits**: Commit after each iteration/improvement cycle with descriptive messages
- **Local Control**: Developer maintains control over when to push to remote repo
- **Conventional Commits**: Use format like `feat:`, `test:`, `fix:`, `refactor:`

### Test-Driven Development (TDD)
- **Test First**: Always write tests before implementing new features
- **Red-Green-Refactor**: Write failing test → implement code → make tests pass → refactor
- **Comprehensive Testing**: Cover all skill calculation logic, XML parsing, and UI behavior
- **Iteration**: Continue until all tests pass

### Feature Implementation Process
1. Create feature branch for new work
2. Write tests for expected functionality
3. Run tests (should fail initially - "red")
4. Implement minimal code to make tests pass ("green")
5. Refactor and improve while keeping tests passing
6. Commit changes with descriptive messages
7. Repeat iterations as needed
