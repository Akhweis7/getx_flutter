import 'package:flutter/material.dart';
import 'package:getx/views/screens/loginscreen.dart';
import 'package:getx/theme/app_theme.dart';

class KanbanApp extends StatelessWidget {
  const KanbanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanban',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginScreen(),
    );
  }
}
