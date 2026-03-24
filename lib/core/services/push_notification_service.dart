/// Push Notification Service
/// Handles Firebase Cloud Messaging and local notifications
library;

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.info('Background message received: ${message.messageId}');
  // Handle background message here if needed
}

/// Push notification service singleton
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _fcmToken;

  // Callbacks
  void Function(RemoteMessage)? onMessageReceived;
  void Function(RemoteMessage)? onMessageOpenedApp;
  void Function(String?)? onTokenRefresh;

  /// Android notification channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'crackthecode_notifications',
    'Crack the Code Notifications',
    description: 'Notifications for new content, reminders, and updates',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize push notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request permission
      final settings = await _requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        logger.warning('Push notification permission not granted');
        return;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      // Only log token in debug mode to prevent sensitive data exposure
      if (kDebugMode) {
        logger.info('FCM Token obtained (length: ${_fcmToken?.length ?? 0})');
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        // Only log token refresh in debug mode
        if (kDebugMode) {
          logger.info('FCM Token refreshed (length: ${token.length})');
        }
        onTokenRefresh?.call(token);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      _isInitialized = true;
      logger.info('Push notification service initialized');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize push notifications', e, stackTrace);
    }
  }

  /// Request notification permission
  Future<NotificationSettings> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logger.info('Notification permission status: ${settings.authorizationStatus}');
    return settings;
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    // Android initialization
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    logger.info('Foreground message received: ${message.notification?.title}');

    // Show local notification
    _showLocalNotification(message);

    // Trigger callback
    onMessageReceived?.call(message);
  }

  /// Handle message opened app (background/terminated)
  void _handleMessageOpenedApp(RemoteMessage message) {
    logger.info('App opened from notification: ${message.notification?.title}');
    onMessageOpenedApp?.call(message);
  }

  /// Handle local notification tap
  void _onNotificationTap(NotificationResponse response) {
    logger.info('Local notification tapped: ${response.payload}');
    // Handle navigation based on payload if needed
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      logger.info('Subscribed to topic: $topic');
    } catch (e) {
      logger.error('Failed to subscribe to topic: $topic', e);
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      logger.info('Unsubscribed from topic: $topic');
    } catch (e) {
      logger.error('Failed to unsubscribe from topic: $topic', e);
    }
  }

  /// Subscribe to relevant topics based on user context
  Future<void> subscribeToUserTopics({
    required String boardId,
    required String classId,
    String? subjectId,
  }) async {
    // Subscribe to general topics
    await subscribeToTopic('all_users');
    await subscribeToTopic('board_$boardId');
    await subscribeToTopic('class_$classId');

    if (subjectId != null) {
      await subscribeToTopic('subject_$subjectId');
    }

    logger.info('Subscribed to user topics: $boardId/$classId${subjectId != null ? "/$subjectId" : ""}');
  }

  /// Get current notification settings
  Future<NotificationSettings> getSettings() async {
    return await _messaging.getNotificationSettings();
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final settings = await getSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}

/// Global push notification service instance
final pushNotificationService = PushNotificationService();
