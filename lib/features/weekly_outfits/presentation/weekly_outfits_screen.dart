import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';
import '../../../data/models/models.dart';

/// Weekly Outfits Screen
/// Displays personalized weekly outfit recommendations
class WeeklyOutfitsScreen extends ConsumerStatefulWidget {
  const WeeklyOutfitsScreen({super.key});

  @override
  ConsumerState<WeeklyOutfitsScreen> createState() => _WeeklyOutfitsScreenState();
}

class _WeeklyOutfitsScreenState extends ConsumerState<WeeklyOutfitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwirlColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'This Week for You',
                      style: SwirlTypography.detailTitle.copyWith(
                        fontSize: 32,
                        color: SwirlColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      'Curated outfits based on your style',
                      style: SwirlTypography.bodyMedium.copyWith(
                        color: SwirlColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Week indicator
                    _buildWeekIndicator(),
                  ],
                ),
              ),
            ),

            // Coordinated Outfits Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Outfits',
                      style: SwirlTypography.cardTitle.copyWith(
                        fontSize: 20,
                        color: SwirlColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coordinated looks ready to wear',
                      style: SwirlTypography.caption.copyWith(
                        color: SwirlColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Outfit Cards
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildOutfitCard(
                        title: index == 0 ? 'Casual Friday' : 'Smart Casual',
                        confidence: index == 0 ? 0.92 : 0.87,
                        items: _getMockOutfitItems(index),
                      ),
                    );
                  },
                  childCount: 2,
                ),
              ),
            ),

            // Individual Items Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'You Might Also Like',
                      style: SwirlTypography.cardTitle.copyWith(
                        fontSize: 20,
                        color: SwirlColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Handpicked items just for you',
                      style: SwirlTypography.caption.copyWith(
                        color: SwirlColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Individual Items Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildIndividualItemCard(index);
                  },
                  childCount: 5,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekIndicator() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SwirlColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SwirlColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 20,
            color: SwirlColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week of ${_formatDate(weekStart)}',
                  style: SwirlTypography.bodyMedium.copyWith(
                    color: SwirlColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_formatDate(weekStart)} - ${_formatDate(weekEnd)}',
                  style: SwirlTypography.caption.copyWith(
                    color: SwirlColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SwirlColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'New',
              style: SwirlTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitCard({
    required String title,
    required double confidence,
    required List<Map<String, String>> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: SwirlColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: SwirlTypography.cardTitle.copyWith(
                          fontSize: 20,
                          color: SwirlColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: SwirlColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(confidence * 100).toInt()}% Match',
                            style: SwirlTypography.caption.copyWith(
                              color: SwirlColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                  color: SwirlColors.primary,
                ),
              ],
            ),
          ),

          // Items Grid
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: items.map((item) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        AspectRatio(
                          aspectRatio: 0.75,
                          child: Container(
                            decoration: BoxDecoration(
                              color: SwirlColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(12),
                              image: item['image'] != null
                                  ? DecorationImage(
                                      image: NetworkImage(item['image']!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: item['image'] == null
                                ? Icon(
                                    Icons.checkroom,
                                    size: 32,
                                    color: SwirlColors.textTertiary,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Label
                        Text(
                          item['label']!,
                          style: SwirlTypography.caption.copyWith(
                            color: SwirlColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Price
                        Text(
                          item['price']!,
                          style: SwirlTypography.caption.copyWith(
                            color: SwirlColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: SwirlColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'View Complete Look',
                  style: SwirlTypography.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndividualItemCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: SwirlColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: SwirlColors.surfaceElevated,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.checkroom,
                      size: 48,
                      color: SwirlColors.textTertiary,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: SwirlColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name',
                  style: SwirlTypography.bodySmall.copyWith(
                    color: SwirlColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Brand Name',
                  style: SwirlTypography.caption.copyWith(
                    color: SwirlColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'AED 299',
                      style: SwirlTypography.bodySmall.copyWith(
                        color: SwirlColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: SwirlColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '85%',
                        style: SwirlTypography.caption.copyWith(
                          color: SwirlColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getMockOutfitItems(int outfitIndex) {
    if (outfitIndex == 0) {
      return [
        {'label': 'T-Shirt', 'price': 'AED 89', 'image': ''},
        {'label': 'Jeans', 'price': 'AED 199', 'image': ''},
        {'label': 'Sneakers', 'price': 'AED 349', 'image': ''},
      ];
    } else {
      return [
        {'label': 'Shirt', 'price': 'AED 149', 'image': ''},
        {'label': 'Chinos', 'price': 'AED 229', 'image': ''},
        {'label': 'Loafers', 'price': 'AED 399', 'image': ''},
      ];
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}