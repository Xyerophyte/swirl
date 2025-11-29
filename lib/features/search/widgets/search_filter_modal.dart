import 'package:flutter/material.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';

/// Search Filter Modal
/// Allows users to filter search results by various criteria
class SearchFilterModal extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const SearchFilterModal({
    super.key,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  State<SearchFilterModal> createState() => _SearchFilterModalState();
}

class _SearchFilterModalState extends State<SearchFilterModal> {
  late Map<String, dynamic> _filters;
  
  // Filter options
  final List<String> _categories = ['All', 'Men', 'Women', 'Unisex', 'Shoes', 'Accessories'];
  final List<String> _styleTags = ['Minimalist', 'Urban Vibe', 'Streetwear Edge', 'Avant-Garde'];
  final List<String> _priceRanges = ['Under 200', '200-500', '500-1000', '1000+'];
  final List<String> _sortOptions = ['Relevance', 'Price: Low to High', 'Price: High to Low', 'Newest'];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.initialFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryFilter(),
                  const SizedBox(height: 24),
                  _buildStyleFilter(),
                  const SizedBox(height: 24),
                  _buildPriceRangeFilter(),
                  const SizedBox(height: 24),
                  _buildSortOptions(),
                  const SizedBox(height: 24),
                  _buildSpecialFilters(),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: SwirlColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filters',
            style: SwirlTypography.detailTitle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset',
              style: SwirlTypography.button.copyWith(
                color: SwirlColors.primary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: SwirlTypography.cardTitle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _filters['category'] == category.toLowerCase();
            return _buildFilterChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _filters['category'] = category.toLowerCase();
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStyleFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Style',
          style: SwirlTypography.cardTitle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _styleTags.map((style) {
            final styleTags = (_filters['styleTags'] as List<String>?) ?? [];
            final isSelected = styleTags.contains(style.toLowerCase().replaceAll(' ', '_'));
            return _buildFilterChip(
              label: style,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  final tags = List<String>.from((_filters['styleTags'] as List<String>?) ?? []);
                  final styleValue = style.toLowerCase().replaceAll(' ', '_');
                  if (tags.contains(styleValue)) {
                    tags.remove(styleValue);
                  } else {
                    tags.add(styleValue);
                  }
                  _filters['styleTags'] = tags;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range (AED)',
          style: SwirlTypography.cardTitle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _priceRanges.map((range) {
            final isSelected = _filters['priceRange'] == range;
            return _buildFilterChip(
              label: range,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _filters['priceRange'] = range;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: SwirlTypography.cardTitle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._sortOptions.map((option) {
          final isSelected = _filters['sortBy'] == option;
          return RadioListTile<String>(
            title: Text(
              option,
              style: SwirlTypography.bodyMedium,
            ),
            value: option,
            groupValue: _filters['sortBy'],
            onChanged: (value) {
              setState(() {
                _filters['sortBy'] = value;
              });
            },
            activeColor: SwirlColors.primary,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSpecialFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special',
          style: SwirlTypography.cardTitle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('On Sale'),
          value: _filters['onSale'] ?? false,
          onChanged: (value) {
            setState(() {
              _filters['onSale'] = value;
            });
          },
          activeColor: SwirlColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Trending'),
          value: _filters['trending'] ?? false,
          onChanged: (value) {
            setState(() {
              _filters['trending'] = value;
            });
          },
          activeColor: SwirlColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('New Arrivals'),
          value: _filters['newArrivals'] ?? false,
          onChanged: (value) {
            setState(() {
              _filters['newArrivals'] = value;
            });
          },
          activeColor: SwirlColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? SwirlColors.primary : SwirlColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? SwirlColors.primary : SwirlColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: SwirlTypography.bodyMedium.copyWith(
            color: isSelected ? Colors.white : SwirlColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: SwirlColors.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(_filters);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SwirlColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'category': 'all',
        'styleTags': <String>[],
        'priceRange': null,
        'sortBy': 'Relevance',
        'onSale': false,
        'trending': false,
        'newArrivals': false,
      };
    });
  }
}