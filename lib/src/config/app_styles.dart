import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static final textTheme = TextTheme(
      overline: TextStyle(
    fontSize: 10.0,
    color: AppColors.black,
  ));

  static final mainTheme = ThemeData(
      buttonTheme: ButtonThemeData(buttonColor: AppColors.secondary),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(250, 40)),
              backgroundColor: MaterialStateProperty.all(AppColors.secondary),
              foregroundColor: MaterialStateProperty.all(AppColors.white),
              textStyle: MaterialStateProperty.all(const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )))),
      fontFamily: 'Poppins',
      useMaterial3: true,
      primaryColor: AppColors.primary,
      toggleableActiveColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      //primaryColorLight: Color(0xFFcbcbcb),
      textTheme: textTheme,
      //appBarTheme: AppBarTheme(centerTitle: false),
      inputDecorationTheme: const InputDecorationTheme(),
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
      ).copyWith(secondary: AppColors.secondary));
}
