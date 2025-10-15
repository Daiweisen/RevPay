import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_local_notifications/flutter_local_notifications.dart' show UILocalNotificationDateInterpretation;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void _onNotificationTapped(NotificationResponse details) {
    // Handle notification tap
    debugPrint('Notification tapped: ${details.payload}');
    // You can navigate to specific screens based on payload
  }

  // Show welcome notification
  static Future<void> showWelcomeNotification(String username) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'welcome_channel',
      'Welcome Notifications',
      channelDescription: 'Welcome messages for new users',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Colors.deepPurple,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      1, // Notification ID
      'Welcome to Revbank! 👋',
      'Hello $username! Welcome to our amazing app. Get ready for an incredible experience!',
      platformChannelSpecifics,
      payload: 'welcome_$username',
    );
  }

  // Show coin reward notification
  static Future<void> showCoinRewardNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'rewards_channel',
      'Reward Notifications',
      channelDescription: 'Coin rewards and bonuses',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Colors.deepPurple,
      
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      2, // Notification ID
      'Welcome!',
      'Start exploring the solution in Revbank',
      platformChannelSpecifics,
      payload: 'coins_reward_10',
    );
  }

  // Schedule a delayed notification
  static Future<void> scheduleDelayedNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(delay),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  // Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Show signup bonus sequence (welcome + coins with delay)
  static Future<void> showSignupBonusSequence(String username) async {
    // Show welcome message immediately
    await showWelcomeNotification(username);

    // Schedule coin reward notification after 3 seconds
    await scheduleDelayedNotification(
      id: 3,
      title: 'Welcome $username!',
      body: 'We are happy to have you bank with Revbank.',
      delay: const Duration(seconds: 3),
      payload: 'signup_bonus_coins',
    );
  }
}


