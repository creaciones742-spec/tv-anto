import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Tema centralizado moderno para TV Anto
/// Una única fuente de verdad para colores, estilos y constantes visuales
class AppTheme {
  AppTheme._();

  // ===================== COLORES DE MARCA =====================
  static const Color primaryPink = Color(0xFFEC4899);
  static const Color primaryPinkLight = Color(0xFFF472B6);
  static const Color primaryPinkDark = Color(0xFFDB2777);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberLight = Color(0xFFFCD34D);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFEF4444);

  // Gradientes principales
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryPink, accentAmber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradientVertical = LinearGradient(
    colors: [primaryPink, accentAmber],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF0a0a0f), Color(0xFF16161f)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1a1a25), Color(0xFF16161f)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===================== SUPERFICIES =====================
  static const Color bgPrimary = Color(0xFF0a0a0f);
  static const Color bgSecondary = Color(0xFF101018);
  static const Color surfacePrimary = Color(0xFF16161f);
  static const Color surfaceSecondary = Color(0xFF1a1a25);
  static const Color surfaceElevated = Color(0xFF22222f);
  static const Color cardBackground = Color(0xFF1e1e2a);

  // ===================== TEXTOS =====================
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE5E7EB); // gray-200
  static const Color textMuted = Color(0xFF9CA3AF); // gray-400
  static const Color textDisabled = Color(0xFF6B7280); // gray-500
  static const Color textOnPrimary = Colors.black;

  // ===================== BORDES Y DIVISORES =====================
  static const Color borderSubtle = Color(0xFF1F2937); // gray-800
  static const Color borderVisible = Color(0xFF374151); // gray-700
  static const Color borderAccent = Color(0xFFEC4899);
  static const Color dividerColor = Color(0xFF1F2937);

  // ===================== ESTADOS =====================
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  // ===================== SOMBRAS =====================
  static const BoxShadow shadowSmall = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowMedium = BoxShadow(
    color: Color(0x60000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow shadowLarge = BoxShadow(
    color: Color(0x80000000),
    blurRadius: 30,
    offset: Offset(0, 8),
  );

  static const BoxShadow shadowGlowPink = BoxShadow(
    color: Color(0x40EC4899),
    blurRadius: 20,
    spreadRadius: 2,
  );

  // ===================== RADIOS =====================
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusRound = 999.0;

  // ===================== ESPACIADO =====================
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // ===================== TIPOGRAFÍA =====================
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
    color: textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textMuted,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textMuted,
  );

  // ===================== THEME DATA =====================
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final ColorScheme colorScheme = isDark
        ? const ColorScheme.dark(
            primary: primaryPink,
            secondary: accentAmber,
            surface: surfacePrimary,
            background: bgPrimary,
            error: errorColor,
            onPrimary: textOnPrimary,
            onSecondary: textOnPrimary,
            onSurface: textPrimary,
            onBackground: textPrimary,
            onError: Colors.white,
            brightness: Brightness.dark,
          )
        : const ColorScheme.light(
            primary: primaryPink,
            secondary: accentAmber,
            surface: Colors.white,
            background: Color(0xFFFAFAFA),
            error: errorColor,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? bgPrimary : const Color(0xFFFAFAFA),
      canvasColor: isDark ? surfacePrimary : Colors.white,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? surfacePrimary : Colors.white,
        foregroundColor: isDark ? textPrimary : Colors.black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: titleLarge.copyWith(
          color: isDark ? textPrimary : Colors.black,
        ),
        iconTheme: IconThemeData(
          color: isDark ? textPrimary : Colors.black,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: isDark ? textPrimary : Colors.black,
          size: 24,
        ),
        shape: const Border(
          bottom: BorderSide(color: borderSubtle, width: 0.5),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: isDark ? surfaceSecondary : Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: BorderSide(
            color: isDark ? borderSubtle : const Color(0xFFE5E7EB),
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.all(spaceSM),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: textOnPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLG,
            vertical: spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusRound),
          ),
          textStyle: labelLarge,
          minimumSize: const Size(88, 48),
        ),
      ),

      // Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLG,
            vertical: spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusRound),
          ),
          textStyle: labelLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? textPrimary : Colors.black,
          side: BorderSide(
            color: isDark ? borderVisible : const Color(0xFFD1D5DB),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLG,
            vertical: spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusRound),
          ),
          textStyle: labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPink,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceMD,
            vertical: spaceSM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusRound),
          ),
          textStyle: labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? bgSecondary : const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: isDark ? borderSubtle : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: primaryPink,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: errorColor,
            width: 1,
          ),
        ),
        labelStyle: bodyMedium.copyWith(color: textMuted),
        hintStyle: bodyMedium.copyWith(color: textDisabled),
        errorStyle: bodySmall.copyWith(color: errorColor),
        floatingLabelStyle: labelMedium.copyWith(color: primaryPink),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryPink,
        inactiveTrackColor: isDark ? borderSubtle : const Color(0xFFE5E7EB),
        thumbColor: primaryPink,
        overlayColor: primaryPink.withValues(alpha: 0.2),
        valueIndicatorColor: primaryPink,
        valueIndicatorTextStyle: labelSmall.copyWith(color: textOnPrimary),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryPink;
          }
          return isDark ? borderVisible : const Color(0xFFD1D5DB);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryPink.withValues(alpha: 0.5);
          }
          return isDark ? borderSubtle : const Color(0xFFE5E7EB);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryPink;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(textOnPrimary),
        side: BorderSide(
          color: isDark ? borderVisible : const Color(0xFFD1D5DB),
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryPink;
          }
          return isDark ? borderVisible : const Color(0xFFD1D5DB);
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? surfacePrimary : Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
        titleTextStyle: headlineSmall.copyWith(
          color: isDark ? textPrimary : Colors.black,
        ),
        contentTextStyle: bodyMedium.copyWith(
          color: isDark ? textSecondary : Colors.black87,
        ),
        surfaceTintColor: isDark ? surfacePrimary : Colors.white,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? surfacePrimary : Colors.white,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXLarge),
          ),
        ),
        surfaceTintColor: isDark ? surfacePrimary : Colors.white,
        modalBackgroundColor: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.3),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? surfaceElevated : Colors.black87,
        contentTextStyle: bodyMedium.copyWith(color: textPrimary),
        actionTextColor: accentAmber,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
        space: spaceMD,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceXS,
        ),
        titleTextStyle: titleMedium,
        subtitleTextStyle: bodySmall,
        leadingAndTrailingTextStyle: bodyMedium,
        iconColor: isDark ? textMuted : textDisabled,
        textColor: isDark ? textPrimary : Colors.black,
        selectedColor: primaryPink,
        selectedTileColor: primaryPink.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? surfaceSecondary : const Color(0xFFF3F4F6),
        disabledColor: isDark ? surfacePrimary : const Color(0xFFF9FAFB),
        selectedColor: primaryPink.withValues(alpha: 0.2),
        secondarySelectedColor: accentAmber.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceXS,
        ),
        labelStyle: labelMedium.copyWith(
          color: isDark ? textPrimary : Colors.black,
        ),
        secondaryLabelStyle: labelMedium.copyWith(color: textOnPrimary),
        brightness: brightness,
        elevation: 0,
        pressElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
          side: BorderSide(
            color: isDark ? borderSubtle : const Color(0xFFE5E7EB),
            width: 0.5,
          ),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: primaryPink,
        unselectedLabelColor: textMuted,
        indicatorColor: primaryPink,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: labelLarge,
        unselectedLabelStyle: labelLarge.copyWith(
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? surfacePrimary : Colors.white,
        indicatorColor: primaryPink.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return labelSmall.copyWith(
              color: primaryPink,
              fontWeight: FontWeight.w600,
            );
          }
          return labelSmall.copyWith(color: textMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryPink, size: 24);
          }
          return IconThemeData(color: textMuted, size: 24);
        }),
        height: 72,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryPink,
        foregroundColor: textOnPrimary,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
        ),
      ),

      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // Scrollbar Theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          isDark ? borderVisible : const Color(0xFFD1D5DB),
        ),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        thickness: WidgetStateProperty.all(6),
        radius: const Radius.circular(radiusRound),
        minThumbLength: 48,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryPink,
        linearTrackColor: isDark ? borderSubtle : const Color(0xFFE5E7EB),
        circularTrackColor: isDark ? borderSubtle : const Color(0xFFE5E7EB),
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? surfaceElevated : Colors.black87,
          borderRadius: BorderRadius.circular(radiusSmall),
          boxShadow: [shadowMedium],
        ),
        textStyle: bodySmall.copyWith(color: textPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceSM,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),

      // Popup Menu Theme
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? surfacePrimary : Colors.white,
        surfaceTintColor: isDark ? surfacePrimary : Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(
            color: isDark ? borderSubtle : const Color(0xFFE5E7EB),
            width: 0.5,
          ),
        ),
        textStyle: bodyMedium.copyWith(
          color: isDark ? textPrimary : Colors.black,
        ),
      ),

      // Text Selection Theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryPink,
        selectionColor: primaryPink.withValues(alpha: 0.3),
        selectionHandleColor: primaryPink,
      ),

      // Splash Factory (sin ripple para mejor rendimiento en TV)
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}

/// Extensiones útiles para el tema
extension AppThemeExtensions on BuildContext {
  /// Acceso rápido a los colores estáticos del tema
  Color get primaryPink => AppTheme.primaryPink;
  Color get primaryPinkLight => AppTheme.primaryPinkLight;
  Color get primaryPinkDark => AppTheme.primaryPinkDark;
  Color get accentAmber => AppTheme.accentAmber;
  Color get accentAmberLight => AppTheme.accentAmberLight;
  Color get accentGreen => AppTheme.accentGreen;
  Color get accentRed => AppTheme.accentRed;

  Color get bgPrimary => AppTheme.bgPrimary;
  Color get bgSecondary => AppTheme.bgSecondary;
  Color get surfacePrimary => AppTheme.surfacePrimary;
  Color get surfaceSecondary => AppTheme.surfaceSecondary;
  Color get surfaceElevated => AppTheme.surfaceElevated;
  Color get cardBackground => AppTheme.cardBackground;

  Color get textPrimary => AppTheme.textPrimary;
  Color get textSecondary => AppTheme.textSecondary;
  Color get textMuted => AppTheme.textMuted;
  Color get textDisabled => AppTheme.textDisabled;
  Color get textOnPrimary => AppTheme.textOnPrimary;

  Color get borderSubtle => AppTheme.borderSubtle;
  Color get borderVisible => AppTheme.borderVisible;
  Color get borderAccent => AppTheme.borderAccent;
  Color get dividerColor => AppTheme.dividerColor;

  // Sombras
  BoxShadow get shadowSmall => AppTheme.shadowSmall;
  BoxShadow get shadowMedium => AppTheme.shadowMedium;
  BoxShadow get shadowLarge => AppTheme.shadowLarge;
  BoxShadow get shadowGlowPink => AppTheme.shadowGlowPink;

  // Radios
  double get radiusSmall => AppTheme.radiusSmall;
  double get radiusMedium => AppTheme.radiusMedium;
  double get radiusLarge => AppTheme.radiusLarge;
  double get radiusXLarge => AppTheme.radiusXLarge;
  double get radiusRound => AppTheme.radiusRound;

  // Espacios
  double get spaceXS => AppTheme.spaceXS;
  double get spaceSM => AppTheme.spaceSM;
  double get spaceMD => AppTheme.spaceMD;
  double get spaceLG => AppTheme.spaceLG;
  double get spaceXL => AppTheme.spaceXL;
  double get spaceXXL => AppTheme.spaceXXL;

  // Gradientes
  LinearGradient get brandGradient => AppTheme.brandGradient;
  LinearGradient get brandGradientVertical => AppTheme.brandGradientVertical;
  LinearGradient get surfaceGradient => AppTheme.surfaceGradient;
  LinearGradient get cardGradient => AppTheme.cardGradient;
}
