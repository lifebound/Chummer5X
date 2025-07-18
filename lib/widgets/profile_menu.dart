import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/shadowrun_character.dart';

class ProfileMenu extends StatelessWidget {
  final ShadowrunCharacter character;
  final VoidCallback? onClose;

  const ProfileMenu({
    super.key,
    required this.character,
    this.onClose,
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
          
          // // Menu options (placeholder for now)
          // _buildMenuItem(
          //   context,
          //   icon: Icons.settings,
          //   title: 'Character Settings',
          //   onTap: () {
          //     // TODO: Implement character settings
          //     onClose?.call();
          //   },
          // ),
          // _buildMenuItem(
          //   context,
          //   icon: Icons.info_outline,
          //   title: 'Character Info',
          //   onTap: () {
          //     // TODO: Implement character info view
          //     onClose?.call();
          //   },
          // ),
          _buildMenuItem(
            context,
            icon: Icons.switch_account,
            title: 'Switch Character',
            onTap: () {
              // TODO: Implement character switching
              onClose?.call();
            },
          ),
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
    Offset? position,
  }) {
    if (kIsWeb || Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.linux) {
      // Desktop/Web: Show modal overlay
      _showDesktopModal(context, character, position);
    } else {
      // Mobile: Show page route with slide transition
      _showMobilePage(context, character);
    }
  }

  static void _showDesktopModal(
    BuildContext context,
    ShadowrunCharacter character,
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
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _MobileProfilePage(character: character),
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

  const _MobileProfilePage({required this.character});

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
            
            // Menu options
            Card(
              child: Column(
                children: [
                  // _buildMobileMenuItem(
                  //   context,
                  //   icon: Icons.settings,
                  //   title: 'Character Settings',
                  //   onTap: () {
                  //     // TODO: Implement character settings
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  // const Divider(height: 1),
                  // _buildMobileMenuItem(
                  //   context,
                  //   icon: Icons.info_outline,
                  //   title: 'Character Info',
                  //   onTap: () {
                  //     // TODO: Implement character info view
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  // const Divider(height: 1),
                  _buildMobileMenuItem(
                    context,
                    icon: Icons.switch_account,
                    title: 'Switch Character',
                    onTap: () {
                      // TODO: Implement character switching
                      Navigator.of(context).pop();
                    },
                  ),
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

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }
}
