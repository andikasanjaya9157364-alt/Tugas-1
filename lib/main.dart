import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'services/firestore_service.dart';
import 'screens/login_screen.dart'; // Tambahan
import 'screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🔥 Tambahan wajib

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  // Optional: Initialize sample data Firestore
  final firestoreService = FirestoreService();
  await firestoreService.initializeSampleData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kasir Cerdas',
            theme: themeProvider.currentTheme,

            // 🔥🔥 DITAMBAHKAN TANPA MENGHAPUS KODEMU
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }
                if (snapshot.hasData) {
                  return const HomeScreen(); // user sudah login
                }
                return const LoginScreen(); // belum login
              },
            ),

            // Login jadi halaman pertama (BIARKAN, TIDAK DIHAPUS)
            initialRoute: '/login',

            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
