/// Theme Toggle Widget
/// Provides UI control for switching between light/dark/system themes
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';
import '../theme/swirl_colors.dart';

/// Theme Toggle Button
/// Shows current theme and allows switching
class ThemeToggleButton extends ConsumerWidget {
  final bool showLabel;
  
  const ThemeToggleButton({
    super.key,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = ref.watch(isDarkModeProvider);
    
    return PopupMenuButton<ThemeMode>(
      icon: Icon(
        _getIconForMode(themeMode, isDark),
        color: isDark ? Colors.white : SwirlColors.textSecondary,
      ),
      tooltip: 'Change theme',
      onSelected: (mode) {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(
                Icons.light_mode,
                color: themeMode == ThemeMode.light 
                    ? SwirlColors.primary 
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                'Light',
                style: TextStyle(
                  color: themeMode == ThemeMode.light 
                      ? SwirlColors.primary 
                      : null,
                  fontWeight: themeMode == ThemeMode.light 
                      ? FontWeight.w600 
                      : null,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(
                Icons.dark_mode,
                color: themeMode == ThemeMode.dark 
                    ? SwirlColors.primary 
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                'Dark',
                style: TextStyle(
                  color: themeMode == ThemeMode.dark 
                      ? SwirlColors.primary 
                      : null,
                  fontWeight: themeMode == ThemeMode.dark 
                      ? FontWeight.w600 
                      : null,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(
                Icons.settings_suggest,
                color: themeMode == ThemeMode.system 
                    ? SwirlColors.primary 
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                'System',
                style: TextStyle(
                  color: themeMode == ThemeMode.system 
                      ? SwirlColors.primary 
                      : null,
                  fontWeight: themeMode == ThemeMode.system 
                      ? FontWeight.w600 
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForMode(ThemeMode mode, bool isDark) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return isDark ? Icons.dark_mode : Icons.light_mode;
    }
  }
}

/// Simple Theme Toggle Switch
/// Quick toggle between light and dark
class ThemeToggleSwitch extends ConsumerWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    
    return Switch(
      value: isDark,
      onChanged: (_) {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
      activeColor: SwirlColors.primary,
    );
  }
}

/// Theme Selection List Tile
/// For use in settings/profile screens
class ThemeSelectionTile extends ConsumerWidget {
  const ThemeSelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = ref.watch(isDarkModeProvider);
    
    return ListTile(
      leading: Icon(
        _getIconForMode(themeMode, isDark),
        color: isDark ? Colors.white : SwirlColors.primary,
      ),
      title: const Text('Theme'),
      subtitle: Text(_getThemeLabel(themeMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showThemeDialog(context, ref, themeMode);
      },
    );
  }

  IconData _getIconForMode(ThemeMode mode, bool isDark) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return isDark ? Icons.dark_mode : Icons.light_mode;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System default'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}