import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../feed/screens/home_screen.dart';
import '../../search/presentation/search_screen.dart';
import '../../swirls/presentation/swirls_screen.dart';
import '../../profile/presentation/profile_screen.dart';

/// Bottom Navigation Widget
/// Provides navigation between main app sections
class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SwirlsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(
            left: AppConstants.spacingMd + AppConstants.spacingXs,
            right: AppConstants.spacingMd + AppConstants.spacingXs,
            bottom: AppConstants.spacingMd + AppConstants.spacingXs,
          ),
          height: AppConstants.bottomNavHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.98),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: SwirlColors.primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home_rounded),
                  _buildNavItem(1, Icons.search_rounded, Icons.search),
                  _buildNavItemWithText(2, '✨'),
                  _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon) {
    final isSelected = _currentIndex == index;
    
    // Get semantic label based on index
    String label;
    String hint;
    switch (index) {
      case 0:
        label = 'Home';
        hint = 'Navigate to home feed';
        break;
      case 1:
        label = 'Search';
        hint = 'Navigate to search';
        break;
      case 3:
        label = 'Profile';
        hint = 'Navigate to profile';
        break;
      default:
        label = 'Navigation item';
        hint = 'Navigate to section';
    }
    
    return Expanded(
      child: Semantics(
        label: label,
        hint: hint,
        button: true,
        selected: isSelected,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 10 : 8),
              decoration: BoxDecoration(
                color: isSelected
                  ? SwirlColors.primary.withOpacity(0.12)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 24,
                color: isSelected
                  ? SwirlColors.primary
                  : SwirlColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemWithText(int index, String emoji) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: Semantics(
        label: 'Swirls',
        hint: 'Navigate to weekly outfit swirls',
        button: true,
        selected: isSelected,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 10 : 8),
              decoration: BoxDecoration(
                color: isSelected
                  ? SwirlColors.primary.withOpacity(0.12)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 24,
                  color: isSelected
                    ? SwirlColors.primary
                    : SwirlColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}