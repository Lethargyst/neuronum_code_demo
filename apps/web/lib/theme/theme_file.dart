import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/gen/fonts.gen.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
  fontFamily: FontFamily.inter,
  useMaterial3: true,
  colorScheme: const ColorScheme(
    primary: AppColors.blue,
    primaryFixed: Color.fromARGB(255, 123, 175, 228),
    onPrimary: AppColors.blueDark,
    primaryContainer: AppColors.blueDarkest,

    secondary: AppColors.pink,
    onSecondary: AppColors.pinkDark,
    secondaryContainer: AppColors.orange,
    
    tertiary: AppColors.white,
    onTertiary: AppColors.green,
    tertiaryContainer: AppColors.greyDark,
    brightness: Brightness.light,
    surface: AppColors.grey,
    onSurface: AppColors.greyDark,
    error: AppColors.red,
    onError: AppColors.red,
    outline: AppColors.grey,
    onSurfaceVariant: Color.fromRGBO(0, 0, 0, 0.149),
    inversePrimary: AppColors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
    labelLarge: TextStyle(
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      height: 1,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
  ),
);
