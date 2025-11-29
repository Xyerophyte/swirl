import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Retry Image Widget
/// Wraps CachedNetworkImage with automatic retry logic and graceful error handling
class RetryImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int maxRetries;
  final Duration retryDelay;
  final BorderRadius? borderRadius;

  const RetryImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.borderRadius,
  });

  @override
  State<RetryImage> createState() => _RetryImageState();
}

class _RetryImageState extends State<RetryImage> {
  int _retryCount = 0;
  String? _currentUrl;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(RetryImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _retryCount = 0;
      _currentUrl = widget.imageUrl;
      _isRetrying = false;
    }
  }

  /// Retry loading the image
  Future<void> _retry() async {
    if (_retryCount >= widget.maxRetries || _isRetrying) return;

    setState(() {
      _isRetrying = true;
      _retryCount++;
    });

    // Wait before retrying
    await Future.delayed(widget.retryDelay);

    if (mounted) {
      setState(() {
        // Add cache-busting parameter
        final uri = Uri.parse(widget.imageUrl);
        _currentUrl = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            'retry': _retryCount.toString(),
            't': DateTime.now().millisecondsSinceEpoch.toString(),
          },
        ).toString();
        _isRetrying = false;
      });
    }
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    // If custom error widget provided, use it
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    // Default error widget with retry
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          if (_retryCount < widget.maxRetries) ...[
            Text(
              _isRetrying ? 'Retrying...' : 'Failed to load',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            if (!_isRetrying)
              TextButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(
                  'Retry (${_retryCount}/${widget.maxRetries})',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ] else ...[
            Text(
              'Image unavailable',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String url) {
    // If custom placeholder provided, use it
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }

    // Default placeholder
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: widget.borderRadius,
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUrl == null || _currentUrl!.isEmpty) {
      return _buildErrorWidget(context, '', 'Empty URL');
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: _currentUrl!,
      fit: widget.fit ?? BoxFit.cover,
      width: widget.width,
      height: widget.height,
      placeholder: _buildPlaceholder,
      errorWidget: (context, url, error) {
        // Auto-retry on error if retries available
        if (_retryCount < widget.maxRetries && !_isRetrying) {
          Future.delayed(widget.retryDelay, () {
            if (mounted) _retry();
          });
        }
        return _buildErrorWidget(context, url, error);
      },
      // Memory cache configuration
      memCacheWidth: widget.width?.toInt(),
      memCacheHeight: widget.height?.toInt(),
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
    );

    // Apply border radius if provided
    if (widget.borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Retry Network Image (simplified version)
/// For cases where you just need retry functionality without customization
class RetryNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const RetryNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return RetryImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      maxRetries: 3,
      retryDelay: const Duration(seconds: 1),
    );
  }
}

/// Retry Avatar Image
/// Specialized for circular avatars with retry
class RetryAvatarImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Widget? placeholder;

  const RetryAvatarImage({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: RetryImage(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          maxRetries: 2,
          placeholder: placeholder,
          errorWidget: Icon(
            Icons.person,
            size: radius,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}