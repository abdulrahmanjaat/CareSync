import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/splash/splash_screen.dart';
import 'core/design/caresync_design_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with error handling
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase initialized successfully');

      // Verify initialization
      if (Firebase.apps.isNotEmpty) {
        debugPrint('Firebase apps count: ${Firebase.apps.length}');
      } else {
        debugPrint(
          'WARNING: Firebase initialization completed but no apps found',
        );
      }
    } else {
      debugPrint('Firebase already initialized');
    }
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    // For platform channel errors, try to continue - might be a build issue
    if (e.toString().contains('channel-error')) {
      debugPrint('Platform channel error detected. Please rebuild the app.');
      // Don't rethrow - allow app to continue but auth won't work
    } else {
      // Re-throw for other errors
      rethrow;
    }
  }

  runApp(const ProviderScope(child: CareSyncApp()));
}

class CareSyncApp extends StatelessWidget {
  const CareSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'CareSync',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: CareSyncDesignSystem.primaryTeal,
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: CareSyncDesignSystem.backgroundLight,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
