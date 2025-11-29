import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/models.dart';
import '../providers/profile_provider.dart';
import '../../../core/constants/app_constants.dart';

/// Style Preferences Page
/// Allows users to add new style preferences from predefined list
class StylePreferencesPage extends ConsumerStatefulWidget {
  final User user;
  
  const StylePreferencesPage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<StylePreferencesPage> createState() => _StylePreferencesPageState();
}

class _StylePreferencesPageState extends ConsumerState<StylePreferencesPage> {
  late Set<String> _selectedStyles;
  bool _isLoading = false;

  // Available style options (same as onboarding)
  final List<Map<String, dynamic>> _availableStyles = [
    {'id': 'casual', 'name': 'Casual', 'icon': Icons.checkroom, 'color': Colors.blue},
    {'id': 'formal', 'name': 'Formal', 'icon': Icons.business_center, 'color': Colors.indigo},
    {'id': 'streetwear', 'name': 'Streetwear', 'icon': Icons.sports_motorsports, 'color': Colors.orange},
    {'id': 'minimalist', 'name': 'Minimalist', 'icon': Icons.minimize, 'color': Colors.grey},
    {'id': 'vintage', 'name': 'Vintage', 'icon': Icons.history, 'color': Colors.brown},
    {'id': 'bohemian', 'name': 'Bohemian', 'icon': Icons.nature_people, 'color': Colors.green},
    {'id': 'sporty', 'name': 'Sporty', 'icon': Icons.sports, 'color': Colors.red},
    {'id': 'elegant', 'name': 'Elegant', 'icon': Icons.diamond, 'color': Colors.purple},
    {'id': 'urban_vibe', 'name': 'Urban Vibe', 'icon': Icons.location_city, 'color': Colors.teal},
    {'id': 'avant_garde', 'name': 'Avant Garde', 'icon': Icons.auto_awesome, 'color': Colors.pink},
  ];

  @override
  void initState() {
    super.initState();
    _selectedStyles = Set<String>.from(widget.user.stylePreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Style Preferences',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_hasChanges())
            TextButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    Text(
                      'Select your favorite styles',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                    VSpace.lg,
                    
                    // Selected count badge
                    if (_selectedStyles.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingMd,
                          vertical: AppConstants.spacingXs + AppConstants.spacingXxs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(AppConstants.radiusButtonSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: AppConstants.iconSizeSm + 2,
                              color: Colors.green[700],
                            ),
                            HSpace.sm,
                            Text(
                              '${_selectedStyles.length} style${_selectedStyles.length == 1 ? '' : 's'} selected',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .scale(delay: 200.ms, duration: 400.ms),

                    VSpace.lg,

                    // Style options grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.15,
                        crossAxisSpacing: AppConstants.spacingMd,
                        mainAxisSpacing: AppConstants.spacingMd,
                      ),
                      itemCount: _availableStyles.length,
                      itemBuilder: (context, index) {
                        final style = _availableStyles[index];
                        final isSelected = _selectedStyles.contains(style['id']);
                        
                        return _buildStyleCard(
                          id: style['id'],
                          name: style['name'],
                          icon: style['icon'],
                          color: style['color'],
                          isSelected: isSelected,
                          delay: index * 50,
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStyleCard({
    required String id,
    required String name,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required int delay,
  }) {
    return GestureDetector(
      onTap: () => _toggleStyle(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(AppConstants.spacingMd - 2),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppConstants.iconSizeXxxl - 8,
              height: AppConstants.iconSizeXxxl - 8,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppConstants.iconSizeXl,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
            VSpace.sm,
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              SizedBox(height: AppConstants.spacingXs + 2),
              Icon(
                Icons.check_circle,
                size: AppConstants.iconSizeMd,
                color: color,
              ),
            ],
          ],
        ),
      ),
    )
      .animate()
      .fadeIn(delay: delay.ms, duration: 400.ms)
      .scale(delay: delay.ms, duration: 400.ms, begin: const Offset(0.8, 0.8));
  }

  void _toggleStyle(String styleId) {
    setState(() {
      if (_selectedStyles.contains(styleId)) {
        _selectedStyles.remove(styleId);
      } else {
        _selectedStyles.add(styleId);
      }
    });
  }

  bool _hasChanges() {
    final originalStyles = Set<String>.from(widget.user.stylePreferences);
    return _selectedStyles.length != originalStyles.length ||
        !_selectedStyles.every((style) => originalStyles.contains(style));
  }

  Future<void> _saveChanges() async {
    if (!_hasChanges()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(profileProvider.notifier).updateStylePreferences(
        _selectedStyles.toList(),
      );

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate changes were saved
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Updated ${_selectedStyles.length} style preference${_selectedStyles.length == 1 ? '' : 's'}',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update styles: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}