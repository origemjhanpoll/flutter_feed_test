import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFF5DEB3); // Bege envelhecido
const Color secondaryColor = Color(0xFF3E2723); // Marrom Café
const Color backgroundColor = Color(0xFFF5DEB3); // Fundo do app
const Color surfaceColor = Color(0xFFEAE0C8); // Bege Claro
const Color errorColor = Color(0xFFB22222); // Vermelho Tijolo
const Color textPrimaryColor = Colors.black; // Texto principal
const Color textSecondaryColor = Colors.white; // Texto sobre botões escuros

final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    onPrimary: textPrimaryColor,
    secondary: secondaryColor,
    onSecondary: textSecondaryColor,
    surface: surfaceColor,
    onSurface: textPrimaryColor,
    error: errorColor,
    onError: textSecondaryColor,
    brightness: Brightness.light,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: secondaryColor),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondaryColor,
    foregroundColor: primaryColor,
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(secondaryColor),
      iconColor: WidgetStatePropertyAll(primaryColor),
      textStyle: WidgetStatePropertyAll(TextStyle(color: primaryColor)),
      overlayColor: WidgetStatePropertyAll(primaryColor.withValues(alpha: 0.1)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    ),
  ),
);
