import 'package:demo_app/screen/add_user.dart';
import 'package:demo_app/screen/home.dart';
import 'package:demo_app/screen/update_user.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case '/add-new':
        return MaterialPageRoute(
          builder: (_) => const AddUser(),
        );
      case '/update-user':
        String data = args.toString();
        return MaterialPageRoute(
          builder: (_) => UpdateUser(
            data: data,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Error: Route not found!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
    }
  }
}
