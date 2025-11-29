import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';
import '../../../data/models/models.dart';
import '../providers/swirls_provider.dart';
import '../../detail/screens/detail_view.dart';

/// Swirls Screen - Grid of liked items
/// Shows all items the user has liked/saved
class SwirlsScreen extends ConsumerStatefulWidget {
  const SwirlsScreen({super.key});

  @override
  ConsumerState<SwirlsScreen> createState() => _SwirlsScreenState();
}

class _SwirlsScreenState extends ConsumerState<SwirlsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh swirls when screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(swirlsProvider.notifier).loadSwirls();
    });
  }

  @override
  Widget build(BuildContext context) {
    final swirlsState = ref.watch(swirlsProvider);

    return Scaffold(
      backgroundColor: SwirlColors.background,
      appBar: AppBar(
        title: Text(
          'Your Swirls',
          style: SwirlTypography.detailTitle.copyWith(
            color: SwirlColors.textPrimary,
          ),
        ),
        backgroundColor: SwirlColors.surface,
        foregroundColor: SwirlColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (swirlsState.swirls.isNotEmpty)
            IconButton(
              onPressed: () {
                // TODO: Add sorting/filtering options
              },
              icon: const Icon(Icons.filter_list),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(swirlsProvider.notifier).loadSwirls();
        },
        color: SwirlColors.primary,
        child: SafeArea(
          child: swirlsState.isLoading
              ? const _LoadingState()
              : swirlsState.error != null
                  ? _ErrorState(error: swirlsState.error!)
                  : swirlsState.swirls.isEmpty
                      ? const _EmptyState()
                      : _SwirlsGrid(swirls: swirlsState.swirls),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(SwirlColors.primary),
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: SwirlColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SwirlColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Retry loading swirls
              ref.read(swirlsProvider.notifier).loadSwirls();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SwirlColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: SwirlColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: SwirlColors.border,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 64,
              color: SwirlColors.textTertiary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No Swirls Yet',
            style: SwirlTypography.detailTitle.copyWith(
              color: SwirlColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Start swiping to save your favorite items here. Right swipe or down swipe to add to Swirls.',
              style: SwirlTypography.bodyMedium.copyWith(
                color: SwirlColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate back to home screen (tab 0)
              DefaultTabController.of(context).animateTo(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SwirlColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Start Swiping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwirlsGrid extends StatelessWidget {
  final List<Swirl> swirls;

  const _SwirlsGrid({required this.swirls});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Slightly taller than square
        ),
        itemCount: swirls.length,
        itemBuilder: (context, index) {
          final swirl = swirls[index];
          return _SwirlCard(swirl: swirl);
        },
      ),
    );
  }
}

class _SwirlCard extends ConsumerWidget {
  final Swirl swirl;

  const _SwirlCard({required this.swirl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = swirl.product!;
    
    return GestureDetector(
      onTap: () {
        // Open detail drawer when tapping on swirl card
        _showDetailDrawer(context, product);
      },
      child: Container(
      decoration: BoxDecoration(
        color: SwirlColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.bestImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Favorite indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: SwirlColors.accent,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product.brand,
                    style: SwirlTypography.bodySmall.copyWith(
                      color: SwirlColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product Name - Protected
                 Text(
                   product.name,
                   style: SwirlTypography.bodyMedium.copyWith(
                     color: SwirlColors.textPrimary,
                     fontWeight: FontWeight.w600,
                   ),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                   softWrap: true,
                 ),
                  const SizedBox(height: 8),
                  // Price - Protected against overflow
                 Row(
                   children: [
                     Flexible(
                       child: Text(
                         product.formattedPrice,
                         style: SwirlTypography.price.copyWith(
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                         ),
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis,
                       ),
                     ),
                     if (product.hasDiscount) ...[
                       const SizedBox(width: 8),
                       Flexible(
                         child: Text(
                           product.formattedOriginalPrice!,
                           style: SwirlTypography.priceOriginal.copyWith(
                             fontSize: 12,
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ],
                   ],
                 ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// Detail drawer function for swirl cards
void _showDetailDrawer(BuildContext context, Product product) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: DetailView(product: product),
                ),
              ),
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}