import 'package:chummer5x/services/enhanced_chumer_xml_service.dart';
import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../services/chumer_xml_service.dart';
import '../services/file_service.dart';
import 'character_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  ShadowrunCharacter? _currentCharacter;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chummer5X'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentCharacter == null) ...[
              const Icon(
                Icons.upload_file,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Chummer5X',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Load a Shadowrun character file to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (_errorMessage != null) ...[
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _loadCharacterFile,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.folder_open),
                label: Text(_isLoading ? 'Loading...' : 'Load Character File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _createSampleCharacter,
                icon: const Icon(Icons.person_add),
                label: const Text('Create Sample Character'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            ] else ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          (_currentCharacter!.name?.isNotEmpty == true)
                              ? _currentCharacter!.name![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _currentCharacter!.name ?? 'Unknown Character',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_currentCharacter!.alias?.isNotEmpty == true) ...[
                        const SizedBox(height: 5),
                        Text(
                          '"${_currentCharacter!.alias}"',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        _currentCharacter!.metatype ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _viewCharacterDetails(),
                            child: const Text('View Details'),
                          ),
                          OutlinedButton(
                            onPressed: () => _loadNewCharacter(),
                            child: const Text('Load New'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _loadCharacterFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final filePath = await FileService.pickChumerFile();
      if (filePath != null) {
        final character = await EnhancedChumerXmlService.parseCharacterFile(filePath);
        if (character != null) {
          setState(() {
            _currentCharacter = character;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to parse character file. Please check if it\'s a valid Chummer XML file.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading file: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadNewCharacter() {
    setState(() {
      _currentCharacter = null;
      _errorMessage = null;
    });
  }

  void _viewCharacterDetails() {
    if (_currentCharacter != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(character: _currentCharacter!),
        ),
      );
    }
  }

  void _createSampleCharacter() {
    final sampleCharacter = ShadowrunCharacter(
      name: 'Sample Runner',
      alias: 'Chrome',
      metatype: 'Human',
      skills: [], // Empty for now
      limits: {}, // Empty for now
      attributes: [
        Attribute(
          name: 'Body',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        Attribute(
          name: 'Agility',
          metatypeCategory: 'Physical',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 1,
        ),
        Attribute(
          name: 'Reaction',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        Attribute(
          name: 'Strength',
          metatypeCategory: 'Physical',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        Attribute(
          name: 'Charisma',
          metatypeCategory: 'Mental',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        Attribute(
          name: 'Intuition',
          metatypeCategory: 'Mental',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        Attribute(
          name: 'Logic',
          metatypeCategory: 'Mental',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 1,
        ),
        Attribute(
          name: 'Willpower',
          metatypeCategory: 'Mental',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        Attribute(
          name: 'Edge',
          metatypeCategory: 'Special',
          totalValue: 2,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 0,
        ),
      ],
      conditionMonitor: const ConditionMonitor(
        physicalCM: 10,
        physicalCMFilled: 2,
        physicalCMOverflow: 4,
        stunCM: 10,
        stunCMFilled: 1,
      ),
      magEnabled: false, // Sample character doesn't have magic enabled
      resEnabled: false, // Sample character doesn't have resonance enabled  
      depEnabled: false, // Sample character doesn't have depth enabled
    );
    
    setState(() {
      _currentCharacter = sampleCharacter;
    });
  }
}
