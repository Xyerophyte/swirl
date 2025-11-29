import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'logging_service.dart';

/// Helper for unawaited futures
void unawaited(Future<void> future) {}

/// Offline Queue Service
/// Manages queued actions when offline and syncs when connection is restored
/// Implements queue persistence, retry logic, and automatic sync
class OfflineQueueService {
  static final OfflineQueueService _instance = OfflineQueueService._internal();
  factory OfflineQueueService() => _instance;
  OfflineQueueService._internal();

  static const String _queueKey = 'offline_action_queue';
  static const int _maxQueueSize = 1000;
  static const int _maxRetries = 3;
  
  final Queue<QueuedAction> _queue = Queue<QueuedAction>();
  final _queueController = StreamController<int>.broadcast();
  bool _isProcessing = false;
  bool _isOnline = true;

  /// Stream of queue size changes
  Stream<int> get queueSizeStream => _queueController.stream;

  /// Current queue size
  int get queueSize => _queue.length;

  /// Whether currently processing queue
  bool get isProcessing => _isProcessing;

  /// Initialize service and load persisted queue
  Future<void> initialize() async {
    try {
      await _loadQueue();
      logger.info('OfflineQueueService initialized with ${_queue.length} pending actions');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize OfflineQueueService', error: e, stackTrace: stackTrace);
    }
  }

  /// Queue an action for later execution
  Future<void> queueAction(QueuedAction action) async {
    try {
      // Check queue size limit
      if (_queue.length >= _maxQueueSize) {
        logger.warning('Queue size limit reached, removing oldest action');
        _queue.removeFirst();
      }

      // Add to queue
      _queue.add(action);
      _queueController.add(_queue.length);

      // Persist queue
      await _saveQueue();

      logger.info('Action queued: ${action.type} (queue size: ${_queue.length})');

      // Try to process immediately if online
      if (_isOnline && !_isProcessing) {
        unawaited(_processQueue());
      }
    } catch (e, stackTrace) {
      logger.error('Failed to queue action', error: e, stackTrace: stackTrace);
    }
  }

  /// Set online status and trigger sync if needed
  Future<void> setOnlineStatus(bool isOnline) async {
    final wasOffline = !_isOnline;
    _isOnline = isOnline;

    if (isOnline && wasOffline && _queue.isNotEmpty) {
      logger.info('Connection restored, processing ${_queue.length} queued actions');
      await _processQueue();
    }
  }

  /// Manually trigger queue processing
  Future<void> syncNow() async {
    if (_isOnline) {
      await _processQueue();
    } else {
      logger.warning('Cannot sync while offline');
    }
  }

  /// Process queued actions
  Future<void> _processQueue() async {
    if (_isProcessing || !_isOnline) return;

    _isProcessing = true;
    
    try {
      while (_queue.isNotEmpty && _isOnline) {
        final action = _queue.first;

        try {
          // Execute action
          final success = await _executeAction(action);

          if (success) {
            // Remove from queue on success
            _queue.removeFirst();
            _queueController.add(_queue.length);
            await _saveQueue();
            
            logger.info('Action executed successfully: ${action.type}');
          } else {
            // Increment retry count
            action.retryCount++;

            if (action.retryCount >= _maxRetries) {
              // Max retries reached, remove from queue
              _queue.removeFirst();
              _queueController.add(_queue.length);
              await _saveQueue();
              
              logger.error(
                'Action failed after ${_maxRetries} retries, removing from queue: ${action.type}',
              );
            } else {
              // Keep in queue for retry
              logger.warning(
                'Action failed (retry ${action.retryCount}/$_maxRetries): ${action.type}',
              );
              
              // Wait before next retry
              await Future.delayed(Duration(seconds: action.retryCount * 2));
            }
          }
        } catch (e, stackTrace) {
          logger.error('Error executing action: ${action.type}', error: e, stackTrace: stackTrace);
          
          action.retryCount++;
          if (action.retryCount >= _maxRetries) {
            _queue.removeFirst();
            _queueController.add(_queue.length);
            await _saveQueue();
          }
        }

        // Small delay between actions to avoid overwhelming the server
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } finally {
      _isProcessing = false;
    }
  }

  /// Execute a queued action
  Future<bool> _executeAction(QueuedAction action) async {
    try {
      switch (action.type) {
        case ActionType.like:
          return await _executeLikeAction(action);
        case ActionType.skip:
          return await _executeSkipAction(action);
        case ActionType.wishlist:
          return await _executeWishlistAction(action);
        case ActionType.updateProfile:
          return await _executeUpdateProfileAction(action);
        default:
          logger.warning('Unknown action type: ${action.type}');
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> _executeLikeAction(QueuedAction action) async {
    // Implementation would call the actual like API
    // For now, simulate success
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  Future<bool> _executeSkipAction(QueuedAction action) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  Future<bool> _executeWishlistAction(QueuedAction action) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  Future<bool> _executeUpdateProfileAction(QueuedAction action) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  /// Load queue from persistent storage
  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueKey);

      if (queueJson != null) {
        final List<dynamic> queueList = jsonDecode(queueJson);
        _queue.clear();
        
        for (final item in queueList) {
          try {
            _queue.add(QueuedAction.fromJson(item));
          } catch (e) {
            logger.warning('Failed to deserialize queued action: $e');
          }
        }

        _queueController.add(_queue.length);
      }
    } catch (e, stackTrace) {
      logger.error('Failed to load queue from storage', error: e, stackTrace: stackTrace);
    }
  }

  /// Save queue to persistent storage
  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueList = _queue.map((action) => action.toJson()).toList();
      await prefs.setString(_queueKey, jsonEncode(queueList));
    } catch (e, stackTrace) {
      logger.error('Failed to save queue to storage', error: e, stackTrace: stackTrace);
    }
  }

  /// Clear all queued actions
  Future<void> clearQueue() async {
    _queue.clear();
    _queueController.add(0);
    await _saveQueue();
    logger.info('Queue cleared');
  }

  /// Dispose resources
  void dispose() {
    _queueController.close();
  }
}

/// Types of actions that can be queued
enum ActionType {
  like,
  skip,
  wishlist,
  updateProfile,
}

/// Queued Action Model
class QueuedAction {
  final String id;
  final ActionType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;

  QueuedAction({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
  });

  factory QueuedAction.fromJson(Map<String, dynamic> json) {
    return QueuedAction(
      id: json['id'] as String,
      type: ActionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ActionType.like,
      ),
      data: Map<String, dynamic>.from(json['data'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }
}