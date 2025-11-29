import 'package:flutter/material.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';

/// Style Filter Chips Widget
/// Allows users to select multiple style preferences with soft bias filtering
class StyleFilterChips extends StatefulWidget {
  final List<String> availableStyles;
  final List<String> selectedStyles;
  final Function(List<String>) onSelectionChanged;
  final bool showLabel;

  const StyleFilterChips({
    super.key,
    this.availableStyles = const [
      'Minimalist',
      'Urban Vibe',
      'Streetwear Edge',
      'Avant-Garde',
    ],
    this.selectedStyles = const [],
    required this.onSelectionChanged,
    this.showLabel = true,
 });

  @override
  State<StyleFilterChips> createState() => _StyleFilterChipsState();
}

class _StyleFilterChipsState extends State<StyleFilterChips>
    with TickerProviderStateMixin {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(
      widget.availableStyles.length,
      (index) => widget.selectedStyles
          .contains(widget.availableStyles[index].toLowerCase().replaceAll(' ', '_')),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Style Filters',
              style: SwirlTypography.detailTitle.copyWith(
                color: SwirlColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.availableStyles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return _StyleChip(
                label: widget.availableStyles[index],
                isSelected: _isSelected[index],
                onTap: () => _toggleSelection(index),
              );
            },
          ),
        ),
      ],
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });

    // Build the list of selected styles (in the format used by the backend)
    final selectedStyles = <String>[];
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected[i]) {
        selectedStyles.add(widget.availableStyles[i].toLowerCase().replaceAll(' ', '_'));
      }
    }

    widget.onSelectionChanged(selectedStyles);
  }
}

class _StyleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? SwirlColors.primary : SwirlColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? SwirlColors.primary : SwirlColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: SwirlColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : SwirlColors.textPrimary,
              ),
            ),
            if (isSelected)
              const SizedBox(width: 6),
            if (isSelected)
              Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
 }
}

/// Style Filter Banner Widget
/// Shows active filters with option to clear
class StyleFilterBanner extends StatelessWidget {
  final List<String> activeFilters;
  final VoidCallback onClear;

  const StyleFilterBanner({
    super.key,
    required this.activeFilters,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SwirlColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SwirlColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: activeFilters.map((filter) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: SwirlColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: SwirlColors.primary,
                    ),
                  ),
                  child: Text(
                    _formatStyleName(filter),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SwirlColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onClear,
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SwirlColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
 }

  String _formatStyleName(String style) {
    // Convert 'minimalist' to 'Minimalist', 'urban_vibe' to 'Urban Vibe', etc.
    return style
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}