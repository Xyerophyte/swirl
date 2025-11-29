import 'package:flutter/material.dart';
import 'dart:async';
import '../services/cache_service.dart';
import '../services/image_precache_service.dart';
import '../theme/swirl_colors.dart';

/// Cache Analytics Overlay
/// Developer tool to monitor cache performance in real-time
/// Shows cache hit rates, image precaching stats, and memory usage
class CacheAnalyticsOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const CacheAnalyticsOverlay({
    super.key,
    required this.child,
    this.enabled = false, // Disabled by default in production
  });

  @override
  State<CacheAnalyticsOverlay> createState() => _CacheAnalyticsOverlayState();
}

class _CacheAnalyticsOverlayState extends State<CacheAnalyticsOverlay> {
  CacheService? _cacheService;
  final ImagePrecacheService _imagePrecache = ImagePrecacheService();
  
  Timer? _updateTimer;
  bool _isExpanded = false;
  
  Map<String, dynamic> _cacheStats = {};
  Map<String, dynamic> _imageStats = {};

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _initializeServices();
    }
  }

  Future<void> _initializeServices() async {
    _cacheService = await CacheService.getInstance();
    _startMonitoring();
  }

  @override
  void dispose() {
    _stopMonitoring();
    super.dispose();
  }

  void _startMonitoring() {
    _updateStats();
    _updateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _updateStats(),
    );
  }

  void _stopMonitoring() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  Future<void> _updateStats() async {
    if (mounted && _cacheService != null) {
      final cacheStats = await _cacheService!.getCacheStats();
      final imageStats = _imagePrecache.getStats();
      
      if (mounted) {
        setState(() {
          _cacheStats = {
            'hits': 0, // Will be tracked separately
            'misses': 0,
            'hit_rate': 0.0,
            'size_mb': (cacheStats['total'] ?? 0) * 0.001, // Rough estimate
            'products': cacheStats['products'] ?? 0,
            'feeds': cacheStats['feeds'] ?? 0,
            'expired': cacheStats['expired'] ?? 0,
          };
          _imageStats = imageStats;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        
        // Analytics Overlay
        Positioned(
          top: 100,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _isExpanded ? 280 : 60,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(-2, 2),
                  ),
                ],
              ),
              child: _isExpanded
                  ? _buildExpandedView()
                  : _buildCollapsedView(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedView() {
    final hitRate = _cacheStats['hit_rate'] ?? 0.0;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.analytics,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          '${hitRate.toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedView() {
    final hits = _cacheStats['hits'] ?? 0;
    final misses = _cacheStats['misses'] ?? 0;
    final hitRate = _cacheStats['hit_rate'] ?? 0.0;
    final sizeMb = _cacheStats['size_mb'] ?? 0.0;
    
    final cachedUrls = _imageStats['cached_urls'] ?? 0;
    final currentlyCaching = _imageStats['currently_caching'] ?? 0;
    final successRate = _imageStats['success_rate'] ?? '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cache Analytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              _isExpanded ? Icons.chevron_right : Icons.chevron_left,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
        
        const Divider(color: Colors.white24, height: 16),
        
        // Data Cache Section
        _buildSection('Data Cache', [
          _buildStatRow('Hit Rate', '${hitRate.toStringAsFixed(1)}%', _getHitRateColor(hitRate)),
          _buildStatRow('Hits', hits.toString(), Colors.green[300]!),
          _buildStatRow('Misses', misses.toString(), Colors.orange[300]!),
          _buildStatRow('Size', '${sizeMb.toStringAsFixed(1)} MB', Colors.blue[300]!),
        ]),
        
        const SizedBox(height: 12),
        
        // Image Cache Section
        _buildSection('Image Cache', [
          _buildStatRow('Success', successRate, _getSuccessRateColor(successRate)),
          _buildStatRow('Cached', cachedUrls.toString(), Colors.green[300]!),
          _buildStatRow('Caching', currentlyCaching.toString(), Colors.yellow[300]!),
        ]),
        
        const SizedBox(height: 12),
        
        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              Icons.refresh,
              'Refresh',
              () => _updateStats(),
            ),
            _buildActionButton(
              Icons.delete_outline,
              'Clear',
              () => _clearCache(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        ...children,
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHitRateColor(double hitRate) {
    if (hitRate >= 80) return Colors.green[300]!;
    if (hitRate >= 60) return Colors.yellow[300]!;
    return Colors.red[300]!;
  }

  Color _getSuccessRateColor(String successRateStr) {
    final successRate = double.tryParse(successRateStr) ?? 0.0;
    if (successRate >= 90) return Colors.green[300]!;
    if (successRate >= 70) return Colors.yellow[300]!;
    return Colors.red[300]!;
  }

  Future<void> _clearCache() async {
    if (_cacheService == null) return;
    
    try {
      await _cacheService!.clearAll();
      _imagePrecache.clearTracking();
      await _updateStats();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}

/// Debug Button Widget
/// Quick access button to toggle cache analytics
class CacheAnalyticsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CacheAnalyticsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: FloatingActionButton.small(
        onPressed: onPressed,
        backgroundColor: Colors.black.withOpacity(0.7),
        child: const Icon(
          Icons.analytics,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}