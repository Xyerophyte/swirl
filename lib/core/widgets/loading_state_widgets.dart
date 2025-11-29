import 'package:flutter/material.dart';
import '../utils/loading_state.dart';

/// Loading State Builder Widget
/// Automatically handles different loading states with appropriate UI
class LoadingStateBuilder<T> extends StatelessWidget {
  final LoadingState<T> state;
  final Widget Function(T data) builder;
  final Widget Function()? loadingBuilder;
  final Widget Function(String error)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final VoidCallback? onRetry;
  
  const LoadingStateBuilder({
    Key? key,
    required this.state,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => loadingBuilder?.call() ?? const DefaultLoadingWidget(),
      success: (data) => builder(data),
      error: (error) => errorBuilder?.call(error) ?? 
          DefaultErrorWidget(
            error: error,
            onRetry: onRetry,
          ),
      idle: () => emptyBuilder?.call() ?? const DefaultEmptyWidget(),
    );
  }
}

/// Paginated Loading State Builder
/// Handles pagination with load more indicator
class PaginatedLoadingStateBuilder<T> extends StatelessWidget {
  final PaginatedLoadingState<T> state;
  final Widget Function(List<T> data) builder;
  final Widget Function()? loadingBuilder;
  final Widget Function(String error)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function()? loadMoreBuilder;
  final VoidCallback? onRetry;
  final VoidCallback? onLoadMore;
  
  const PaginatedLoadingStateBuilder({
    Key? key,
    required this.state,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.loadMoreBuilder,
    this.onRetry,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initial loading
    if (state.isLoading && !state.hasData) {
      return loadingBuilder?.call() ?? const DefaultLoadingWidget();
    }
    
    // Error state
    if (state.hasError && !state.hasData) {
      return errorBuilder?.call(state.error!) ?? 
          DefaultErrorWidget(
            error: state.error!,
            onRetry: onRetry,
          );
    }
    
    // Empty state
    if (state.hasData && state.data!.isEmpty) {
      return emptyBuilder?.call() ?? const DefaultEmptyWidget();
    }
    
    // Data with optional load more indicator
    return Column(
      children: [
        Expanded(child: builder(state.data!)),
        if (state.isLoadingMore)
          loadMoreBuilder?.call() ?? 
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: DefaultLoadMoreWidget(),
              ),
        if (state.hasError && state.hasData)
          DefaultErrorWidget(
            error: state.error!,
            onRetry: onRetry,
            isInline: true,
          ),
      ],
    );
  }
}

/// Progress Loading State Builder
/// Shows progress indicator for uploads/downloads
class ProgressLoadingStateBuilder<T> extends StatelessWidget {
  final ProgressLoadingState<T> state;
  final Widget Function(T data) builder;
  final Widget Function(double progress, String? message)? progressBuilder;
  final Widget Function(String error)? errorBuilder;
  final VoidCallback? onRetry;
  
  const ProgressLoadingStateBuilder({
    Key? key,
    required this.state,
    required this.builder,
    this.progressBuilder,
    this.errorBuilder,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return progressBuilder?.call(state.progress, state.progressMessage) ??
          DefaultProgressWidget(
            progress: state.progress,
            message: state.progressMessage,
          );
    }
    
    if (state.hasError) {
      return errorBuilder?.call(state.error!) ?? 
          DefaultErrorWidget(
            error: state.error!,
            onRetry: onRetry,
          );
    }
    
    if (state.hasData) {
      return builder(state.data!);
    }
    
    return const SizedBox.shrink();
  }
}

/// Default Loading Widget
class DefaultLoadingWidget extends StatelessWidget {
  final String? message;
  
  const DefaultLoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// Default Error Widget
class DefaultErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final bool isInline;
  
  const DefaultErrorWidget({
    Key? key,
    required this.error,
    this.onRetry,
    this.isInline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: isInline ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: isInline ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: isInline ? 32 : 64,
          color: Colors.red,
        ),
        SizedBox(height: isInline ? 8 : 16),
        Text(
          error,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          SizedBox(height: isInline ? 8 : 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ],
    );
    
    if (isInline) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      );
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}

/// Default Empty Widget
class DefaultEmptyWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;
  
  const DefaultEmptyWidget({
    Key? key,
    this.message,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No items found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Default Load More Widget
class DefaultLoadMoreWidget extends StatelessWidget {
  const DefaultLoadMoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 12),
        Text('Loading more...'),
      ],
    );
  }
}

/// Default Progress Widget
class DefaultProgressWidget extends StatelessWidget {
  final double progress;
  final String? message;
  
  const DefaultProgressWidget({
    Key? key,
    required this.progress,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer Loading Placeholder
/// Shows skeleton loading effect
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  
  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pull to Refresh Wrapper
/// Wraps content with pull-to-refresh functionality
class PullToRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final bool enabled;
  
  const PullToRefreshWrapper({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}