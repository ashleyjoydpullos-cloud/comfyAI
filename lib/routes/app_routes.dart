import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/report_form_screen.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const chat = '/chat';
  static const report = '/report';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const HomeScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        chat: (_) => const ChatScreen(),
        report: (_) => const ReportFormScreen(),
      };
}