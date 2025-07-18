import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';

class ProfileMenu extends StatelessWidget {
  final ShadowrunCharacter character;
  final List<ShadowrunCharacter> allCharacters;
  final VoidCallback? onClose;
  final VoidCallback? onLoadCharacter;
  final Function(ShadowrunCharacter)? onSwitchCharacter;

  const ProfileMenu({
    super.key,
    required this.character,
    this.allCharacters = const [],
    this.onClose,
    this.onLoadCharacter,
    this.onSwitchCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Profile picture
          _buildCharacterAvatar(context),
          const SizedBox(height: 16),
          
          // Character info
          Text(
            character.name ?? 'Unknown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (character.alias?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              '"${character.alias}"',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            character.metatype ?? 'Unknown',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // Menu options based on character count
          if (allCharacters.length <= 1) ...[
            // Single character or no other characters - show "Load Character" option
            _buildMenuItem(
              context,
              icon: Icons.folder_open,
              title: 'Load Character',
              onTap: () {
                onLoadCharacter?.call();
                onClose?.call();
              },
            ),
          ] else ...[
            // Multiple characters - show character switching options
            Text(
              'Switch Character',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            
            // List other characters (excluding current one)
            ...allCharacters
                .where((char) => char != character)
                .take(3) // Show max 3 characters to avoid overflow
                .map((char) => _buildCharacterMenuItem(context, char)),
            
            // Show "Load Another" option
            const SizedBox(height: 8),
            _buildMenuItem(
              context,
              icon: Icons.add,
              title: 'Load Another Character',
              onTap: () {
                onLoadCharacter?.call();
                onClose?.call();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCharacterAvatar(BuildContext context) {
    if (character.mugshot != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: MemoryImage(character.mugshot!.imageData),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    } else {
      // Generate avatar from name initials
      final initials = _getInitials(character.name ?? 'Unknown');
      return CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
  }

  Widget _buildSmallCharacterAvatar(BuildContext context, ShadowrunCharacter char, {double radius = 16}) {
    if (char.mugshot != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(char.mugshot!.imageData),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    } else {
      // Generate avatar from name initials
      final initials = _getInitials(char.name ?? 'Unknown');
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: radius * 0.6, // Scale font size with radius
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterMenuItem(BuildContext context, ShadowrunCharacter char) {
    return InkWell(
      onTap: () {
        onSwitchCharacter?.call(char);
        onClose?.call();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            _buildSmallCharacterAvatar(context, char, radius: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    char.name ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (char.alias?.isNotEmpty == true)
                    Text(
                      '"${char.alias}"',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }

  // Static method to show the profile menu
  static void show(
    BuildContext context,
    ShadowrunCharacter character, {
    List<ShadowrunCharacter> allCharacters = const [],
    VoidCallback? onLoadCharacter,
    Function(ShadowrunCharacter)? onSwitchCharacter,
    Offset? position,
  }) {
    // Check screen size to determine UI pattern
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileSize = screenWidth < 768; // Common mobile breakpoint
    
    // Use mobile UI for mobile-sized screens regardless of platform
    // Use desktop UI for larger screens (desktop/tablet)
    if (isMobileSize) {
      // Mobile-sized screen: Show page route with slide transition
      _showMobilePage(context, character, allCharacters, onLoadCharacter, onSwitchCharacter);
    } else {
      // Desktop/tablet-sized screen: Show modal overlay
      _showDesktopModal(context, character, allCharacters, onLoadCharacter, onSwitchCharacter, position);
    }
  }

  static void _showDesktopModal(
    BuildContext context,
    ShadowrunCharacter character,
    List<ShadowrunCharacter> allCharacters,
    VoidCallback? onLoadCharacter,
    Function(ShadowrunCharacter)? onSwitchCharacter,
    Offset? position,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: (position?.dy ?? 100) + 40, // Below the avatar
                right: 20, // Align to right side like Google
                child: GestureDetector(
                  onTap: () {}, // Prevent dismissal when tapping the menu
                  child: ProfileMenu(
                    character: character,
                    allCharacters: allCharacters,
                    onLoadCharacter: onLoadCharacter,
                    onSwitchCharacter: onSwitchCharacter,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showMobilePage(
    BuildContext context,
    ShadowrunCharacter character,
    List<ShadowrunCharacter> allCharacters,
    VoidCallback? onLoadCharacter,
    Function(ShadowrunCharacter)? onSwitchCharacter,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _MobileProfilePage(
              character: character,
              allCharacters: allCharacters,
              onLoadCharacter: onLoadCharacter,
              onSwitchCharacter: onSwitchCharacter,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _MobileProfilePage extends StatelessWidget {
  final ShadowrunCharacter character;
  final List<ShadowrunCharacter> allCharacters;
  final VoidCallback? onLoadCharacter;
  final Function(ShadowrunCharacter)? onSwitchCharacter;

  const _MobileProfilePage({
    required this.character,
    this.allCharacters = const [],
    this.onLoadCharacter,
    this.onSwitchCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: <Widget>[IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile picture
            _buildCharacterAvatar(context),
            const SizedBox(height: 24),
            
            // Character info
            Text(
              character.name ?? 'Unknown',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (character.alias?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                '"${character.alias}"',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              character.metatype ?? 'Unknown',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Menu options based on character count
            Card(
              child: Column(
                children: [
                  if (allCharacters.length <= 1) ...[
                    // Single character or no other characters - show "Load Character" option
                    _buildMobileMenuItem(
                      context,
                      icon: Icons.folder_open,
                      title: 'Load Character',
                      onTap: () {
                        onLoadCharacter?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ] else ...[
                    // Multiple characters - show character switching options
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Switch Character',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    
                    // List other characters (excluding current one)
                    ...allCharacters
                        .where((char) => char != character)
                        .take(5) // Show more characters on mobile
                        .map((char) => _buildMobileCharacterMenuItem(context, char)),
                    
                    // Show "Load Another" option
                    _buildMobileMenuItem(
                      context,
                      icon: Icons.add,
                      title: 'Load Another Character',
                      onTap: () {
                        onLoadCharacter?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterAvatar(BuildContext context) {
    if (character.mugshot != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: MemoryImage(character.mugshot!.imageData),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    } else {
      // Generate avatar from name initials
      final initials = _getInitials(character.name ?? 'Unknown');
      return CircleAvatar(
        radius: 60,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
  }

  Widget _buildMobileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildMobileCharacterMenuItem(BuildContext context, ShadowrunCharacter char) {
    return ListTile(
      leading: _buildSmallCharacterAvatar(context, char, radius: 20),
      title: Text(char.name ?? 'Unknown'),
      subtitle: char.alias?.isNotEmpty == true
          ? Text('"${char.alias}"')
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        onSwitchCharacter?.call(char);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildSmallCharacterAvatar(BuildContext context, ShadowrunCharacter char, {double radius = 16}) {
    if (char.mugshot != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(char.mugshot!.imageData),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    } else {
      // Generate avatar from name initials
      final initials = _getInitials(char.name ?? 'Unknown');
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: radius * 0.6, // Scale font size with radius
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }
}
