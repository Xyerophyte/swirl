import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../providers/profile_provider.dart';
import '../../onboarding/services/onboarding_service.dart';

/// Profile Screen - Beautiful user profile with statistics
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: profileState.isLoading
          ? _buildLoadingState()
          : profileState.error != null
              ? _buildErrorState(profileState.error!)
              : profileState.user != null
                  ? _buildProfileContent(profileState.user!)
                  : _buildEmptyState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Loading your profile...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildErrorState(String error) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
              )
                .animate()
                .scale(delay: 100.ms, duration: 500.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 32),
              
              Text(
                'Profile Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 16),
              
              Text(
                'Your profile hasn\'t been created yet. Complete the onboarding to set up your account.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {
                  ref.read(profileProvider.notifier).loadProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return _buildErrorState('User not found');
  }

  Widget _buildProfileContent(User user) {
    return CustomScrollView(
      slivers: [
        // Profile Header with gradient
        SliverToBoxAdapter(
          child: _buildProfileHeader(user),
        ),
        
        // Insights Section (6 metrics grid)
        SliverToBoxAdapter(
          child: _buildInsightsSection(user),
        ),
        
        // Style Preferences
        SliverToBoxAdapter(
          child: _buildStylePreferencesSection(user),
        ),
        
        // Settings
        SliverToBoxAdapter(
          child: _buildSettingsSection(),
        ),

        // Extra spacing to clear bottom navigation
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppConstants.bottomNavHeight +
                    AppConstants.floatingNavBottom +
                    AppConstants.spacingLg,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.grey[900]!,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: user.avatarUrl != null
                  ? Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          )
            .animate()
            .scale(delay: 100.ms, duration: 600.ms, curve: Curves.elasticOut)
            .fadeIn(),
          
          const SizedBox(height: 24),
          
          // Name
          Text(
            user.displayName ?? 'Guest User',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 8),
          
          // Engagement Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Text(
                  user.engagementLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
            .animate()
            .fadeIn(delay: 300.ms)
            .scale(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.white,
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[400],
      ),
    );
  }


  Widget _buildInsightsSection(User user) {
    // Get brands followed count from provider
    final brandsFollowed = ref.watch(brandsFollowedCountProvider);
    
    // Calculate engagement rate
    final engagementRate = user.totalSwipes > 0
        ? ((user.totalSwirls / user.totalSwipes) * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Insights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          
          // Row 1: Engagement Rate & Total Swirls
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.trending_up,
                  label: 'Engagement Rate',
                  value: '$engagementRate%',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.favorite,
                  label: 'Total Swirls',
                  value: user.totalSwirls.toString(),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 2: Total Swipes & Avg Liked Price
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.swipe,
                  label: 'Total Swipes',
                  value: user.totalSwipes.toString(),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.attach_money,
                  label: 'Avg Liked Price',
                  value: user.avgLikedPrice != null
                      ? '\$${user.avgLikedPrice!.toStringAsFixed(0)}'
                      : 'N/A',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 3: Brands Followed & Days Active
          Row(
            children: [
              Expanded(
                child: brandsFollowed.when(
                  data: (count) => _buildInsightCard(
                    icon: Icons.store,
                    label: 'Brands Followed',
                    value: count.toString(),
                    color: Colors.purple,
                  ),
                  loading: () => _buildInsightCard(
                    icon: Icons.store,
                    label: 'Brands Followed',
                    value: '...',
                    color: Colors.purple,
                  ),
                  error: (_, __) => _buildInsightCard(
                    icon: Icons.store,
                    label: 'Brands Followed',
                    value: '0',
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.calendar_today,
                  label: 'Days Active',
                  value: user.daysActive.toString(),
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(delay: 300.ms, duration: 500.ms)
      .slideY(begin: 0.2, end: 0, delay: 300.ms);
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStylePreferencesSection(User user) {
    final styles = user.stylePreferences;
    final hasStyles = styles.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Style Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  if (hasStyles)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${styles.length} Active',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed(
                        '/style-preferences',
                        arguments: user,
                      );
                      
                      // Reload profile if changes were saved
                      if (result == true && mounted) {
                        ref.read(profileProvider.notifier).loadProfile();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          hasStyles
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: styles
                              .map((style) => _buildEditableStyleChip(style, user))
                              .toList(),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.style_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No style preferences yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your favorite styles',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    )
      .animate()
      .fadeIn(delay: 400.ms, duration: 500.ms)
      .slideY(begin: 0.2, end: 0, delay: 400.ms);
  }

  String _formatStyleName(String style) {
    return style
        .split('_')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildEditableStyleChip(String style, User user) {
    final formattedName = _formatStyleName(style);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formattedName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _removeStyle(style, user),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeStyle(String style, User user) async {
    final updatedStyles = List<String>.from(user.stylePreferences)
      ..remove(style);
    
    try {
      await ref.read(profileProvider.notifier).updateStylePreferences(updatedStyles);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed ${_formatStyleName(style)}'),
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
            content: Text('Failed to remove style: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your information',
            color: Colors.blue,
          ),
          _buildDivider(),
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage push notifications',
            color: Colors.orange,
          ),
          _buildDivider(),
          _buildSettingsItem(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Customize app theme',
            color: Colors.purple,
          ),
          _buildDivider(),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            color: Colors.teal,
          ),
          _buildDivider(),
          _buildSettingsItem(
            icon: Icons.refresh,
            title: 'Restart Onboarding',
            subtitle: 'Go through the setup again',
            color: Colors.red,
            onTap: _showRestartOnboardingDialog,
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(delay: 600.ms, duration: 500.ms)
      .slideY(begin: 0.2, end: 0, delay: 600.ms);
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 76,
      color: Colors.grey[200],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {
          // Handle Edit Profile navigation
          if (title == 'Edit Profile') {
            final user = ref.read(profileProvider).user;
            if (user != null) {
              Navigator.of(context).pushNamed(
                '/edit-profile',
                arguments: user,
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title - Coming soon!'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                backgroundColor: Colors.black,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRestartOnboardingDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        ),
        title: const Text(
          'Restart Onboarding?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This will reset your preferences and take you through the setup process again. Your profile data will be preserved.',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
                vertical: AppConstants.spacingMd,
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
                vertical: AppConstants.spacingMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusButtonLarge),
              ),
            ),
            child: const Text(
              'Restart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _restartOnboarding();
    }
  }

  Future<void> _restartOnboarding() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(AppConstants.spacingXl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  'Resetting...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Reset onboarding state
      await OnboardingService.resetOnboarding();

      if (mounted) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Navigate back to root and replace with onboarding
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/onboarding',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        // Close loading dialog if still open
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restart onboarding: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}