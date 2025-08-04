import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/auth_provider.dart';
import 'screens/shared/splash_screen.dart';
import 'constants/app_constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const DwelloApp());
}

class DwelloApp extends StatelessWidget {
  const DwelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(
            AppConstants.primaryColor.value,
            <int, Color>{
              50: AppConstants.primaryColor.withOpacity(0.1),
              100: AppConstants.primaryColor.withOpacity(0.2),
              200: AppConstants.primaryColor.withOpacity(0.3),
              300: AppConstants.primaryColor.withOpacity(0.4),
              400: AppConstants.primaryColor.withOpacity(0.5),
              500: AppConstants.primaryColor.withOpacity(0.6),
              600: AppConstants.primaryColor.withOpacity(0.7),
              700: AppConstants.primaryColor.withOpacity(0.8),
              800: AppConstants.primaryColor.withOpacity(0.9),
              900: AppConstants.primaryColor,
            },
          ),
          primaryColor: AppConstants.primaryColor,
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          cardColor: AppConstants.cardColor,
          dividerColor: AppConstants.dividerColor,
          
          // Text Theme
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(
            displayLarge: AppConstants.headingStyle.copyWith(fontSize: 32),
            displayMedium: AppConstants.headingStyle.copyWith(fontSize: 28),
            displaySmall: AppConstants.headingStyle,
            headlineMedium: AppConstants.subHeadingStyle,
            headlineSmall: AppConstants.subHeadingStyle.copyWith(fontSize: 16),
            titleLarge: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600),
            titleMedium: AppConstants.bodyStyle,
            titleSmall: AppConstants.bodyStyle.copyWith(fontSize: 14),
            bodyLarge: AppConstants.bodyStyle,
            bodyMedium: AppConstants.bodyStyle.copyWith(fontSize: 14),
            bodySmall: AppConstants.captionStyle,
            labelLarge: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.w500),
            labelMedium: AppConstants.captionStyle.copyWith(fontWeight: FontWeight.w500),
            labelSmall: AppConstants.captionStyle.copyWith(fontSize: 12),
          ),
          
          // Color Scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            primary: AppConstants.primaryColor,
            secondary: AppConstants.secondaryColor,
            tertiary: AppConstants.accentColor,
            error: AppConstants.errorColor,
            surface: AppConstants.cardColor,
          ),
          
          // App Bar Theme
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Outlined Button Theme
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.primaryColor,
              side: const BorderSide(color: AppConstants.primaryColor),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppConstants.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
            hintStyle: GoogleFonts.poppins(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            labelStyle: GoogleFonts.poppins(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          
          // Card Theme
          cardTheme: CardTheme(
            color: AppConstants.cardColor,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
          ),
          
          // Floating Action Button Theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
          
          // Bottom Navigation Bar Theme
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppConstants.cardColor,
            selectedItemColor: AppConstants.primaryColor,
            unselectedItemColor: AppConstants.textSecondaryColor,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
          
          // Tab Bar Theme
          tabBarTheme: TabBarTheme(
            labelColor: AppConstants.primaryColor,
            unselectedLabelColor: AppConstants.textSecondaryColor,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: AppConstants.primaryColor,
                width: 2,
              ),
            ),
          ),
          
          // Chip Theme
          chipTheme: ChipThemeData(
            backgroundColor: AppConstants.backgroundColor,
            selectedColor: AppConstants.primaryColor,
            disabledColor: AppConstants.dividerColor,
            labelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
              vertical: 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            ),
          ),
          
          // Dialog Theme
          dialogTheme: DialogTheme(
            backgroundColor: AppConstants.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
            contentTextStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          
          // Snack Bar Theme
          snackBarTheme: SnackBarThemeData(
            backgroundColor: AppConstants.textPrimaryColor,
            contentTextStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
