import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/swirl_repository.dart';

/// Swirls State
class SwirlsState {
  final List<Swirl> swirls;
  final bool isLoading;
  final String? error;
  final int totalSwirls;

  const SwirlsState({
    this.swirls = const [],
    this.isLoading = false,
    this.error,
    this.totalSwirls = 0,
  });

  SwirlsState copyWith({
    List<Swirl>? swirls,
    bool? isLoading,
    String? error,
    int? totalSwirls,
  }) {
    return SwirlsState(
      swirls: swirls ?? this.swirls,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalSwirls: totalSwirls ?? this.totalSwirls,
    );
 }
}

/// Swirls Notifier
class SwirlsNotifier extends StateNotifier<SwirlsState> {
  final SwirlRepository _swirlRepo;
  final String _userId;

  SwirlsNotifier({
    required SwirlRepository swirlRepo,
    required String userId,
  })  : _swirlRepo = swirlRepo,
        _userId = userId,
        super(const SwirlsState()) {
    loadSwirls();
  }

  /// Load user's swirls
  Future<void> loadSwirls() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final swirls = await _swirlRepo.getUserSwirls(
        userId: _userId,
        limit: 100, // Load first 100 swirls
      );

      final count = await _swirlRepo.getSwirlCount(_userId);

      state = state.copyWith(
        swirls: swirls,
        isLoading: false,
        totalSwirls: count,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Remove a swirl
  Future<void> removeSwirl(String productId) async {
    try {
      await _swirlRepo.removeSwirl(
        userId: _userId,
        productId: productId,
      );

      // Update state by removing the swirl
      final updatedSwirls = state.swirls
          .where((swirl) => swirl.product?.id != productId)
          .toList();

      state = state.copyWith(
        swirls: updatedSwirls,
        totalSwirls: state.totalSwirls - 1,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Toggle swirl (add/remove)
  Future<void> toggleSwirl(String productId, ItemSource source) async {
    try {
      final isAdded = await _swirlRepo.toggleSwirl(
        userId: _userId,
        productId: productId,
        source: source,
      );

      if (isAdded) {
        // If added, we need to reload to get the new swirl with product data
        await loadSwirls();
      } else {
        // If removed, update state directly
        final updatedSwirls = state.swirls
            .where((swirl) => swirl.product?.id != productId)
            .toList();

        state = state.copyWith(
          swirls: updatedSwirls,
          totalSwirls: state.totalSwirls - 1,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Providers
// Using centralized providers from core/providers/app_providers.dart

// Swirls provider
final swirlsProvider = StateNotifierProvider<SwirlsNotifier, SwirlsState>((ref) {
  final swirlRepo = ref.watch(swirlRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  return SwirlsNotifier(
    swirlRepo: swirlRepo,
    userId: userId,
  );
});