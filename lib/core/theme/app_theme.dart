import 'package:flutter/material.dart';

class AppColors {
  // Modern blue gradient colors
  static const Color primary = Color(0xFF1E88E5);        // Modern blue
  static const Color primaryDark = Color(0xFF1565C0);    // Darker blue for gradients
  static const Color primaryLight = Color(0xFF42A5F5);   // Lighter blue variant
  static const Color primaryContainer = Color(0xFFD1E4FF); // Light container color
  
  // Secondary colors
  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryContainer = Color(0xFFFFDBC8);
  
  // Background and surface colors
  static const Color background = Color(0xFFF8FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F7FA);
  
  // Text colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Utility colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Card and input colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF3F4F6);
  
  // Shadow color
  static const Color shadowColor = Color(0x1A000000); // 10% black opacity
  static const Color shadowColorLight = Color(0x0D000000); // 5% black opacity
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Modern blue-based color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryDark,
        
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: Color(0xFF8C2D00),
        
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        
        outline: AppColors.divider,
        shadow: AppColors.shadowColor,
      ),
      
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar with modern styling
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColors.primary.withOpacity(0.1),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card theme with soft shadows and rounded corners (16px as requested)
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.shadowColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Input decoration with modern styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
        ),
      ),
      
      // Elevated button with modern blue gradient feel
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
      
      // Text button styling
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          animationDuration: const Duration(milliseconds: 150),
        ),
      ),
      
      // Outlined button styling
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
      
      // Primary icon theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.textOnPrimary,
        size: 24,
      ),
      
      // Chip theme for modern look
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        deleteIconColor: AppColors.textSecondary,
        disabledColor: AppColors.divider,
        selectedColor: AppColors.primaryContainer,
        secondarySelectedColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        shadowColor: AppColors.shadowColor,
      ),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shadowColor: AppColors.shadowColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      
      // Navigation bar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        shadowColor: AppColors.shadowColorLight,
        elevation: 3,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: MaterialStateProperty.all(
          const IconThemeData(
            size: 24,
          ),
        ),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shadowColor: AppColors.shadowColor,
      ),
      
      // Page transitions for smooth animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // Material 3 motion system for subtle animations
      materialTapTargetSize: MaterialTapTargetSize.padded,
      
      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
