import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favourite_provider.dart';
import 'routes/app_routes.dart';
import 'services/firestore_service.dart';
import 'utils/theme/app_theme.dart';


import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  // 1. Initialize Flutter bindings immediately
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Perform initialization with proper async error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Stripe key
    Stripe.publishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';

    // Start background services and handle their errors separately
    try {
      await Future.wait([
        Stripe.instance.applySettings(),
        FirestoreService().seedDatabase(),
      ]);
    } catch (e) {
      debugPrint('Background Init Error: $e');
    }
  } catch (e) {
    debugPrint('Firebase Init Error: $e');
  }

  // 3. Set UI style and run app immediately
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // If still waiting for Firebase, show a minimal loading state inside the app
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFF1A3D2B), // Brand Green
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE5D5B5)),
                ),
              ),
            ),
          );
        }

        // Once Firebase is ready, load the full app
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => FavouriteProvider()),
          ],
          child: MaterialApp.router(
            title: 'AURA Fashion',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
