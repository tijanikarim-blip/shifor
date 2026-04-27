import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/auth_wrapper.dart';

bool _useDemoMode = true; // Set to false when Firebase is fully configured with SHA keys

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!_useDemoMode) {
    await Firebase.initializeApp();
  }
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const ShiforApp());
}

class ShiforApp extends StatelessWidget {
  const ShiforApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(_useDemoMode)),
      ],
      child: MaterialApp(
        title: 'Shifor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}