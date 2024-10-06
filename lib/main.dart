import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz; // For timezone initialization
import 'services/notification_service.dart'; // For notifications
import 'views/home_screen.dart'; // Home screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize time zones for local notifications
  tz.initializeTimeZones();

  // Initialize the notification service
  await NotificationService().initNotification(); // Initialize notifications

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'ToDo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Use a consistent theme throughout the app
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Set HomeScreen as the default screen
    );
  }
}
