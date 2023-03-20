import 'package:flutter/material.dart';

class AppColors {
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);

  static Color primary = const Color.fromARGB(255, 32, 57, 107);
  static Color secondary = const Color.fromARGB(255, 255, 103, 84);
  static Color tertiary = const Color.fromARGB(255, 58, 196, 229);

  static Color secondaryCake = const Color.fromARGB(255, 255, 244, 242);

  static Color transparent = const Color.fromARGB(0, 0, 0, 0);

  static colorByCategoryBG(String category) {
    switch (category) {
      case "Ficció":
        {
          return Color.fromARGB(255, 234, 251, 205);
        }
      case "Infantil":
        {
          return Color.fromARGB(255, 255, 248, 221);
        }
      case "Novel·la":
        {
          return Color.fromARGB(255, 216, 234, 255);
        }
    }
  }

  static colorByCategoryTitle(String category) {
    switch (category) {
      case "Ficció":
        {
          return Color.fromARGB(255, 163, 241, 30);
        }
      case "Infantil":
        {
          return Color.fromARGB(255, 244, 197, 27);
        }
      case "Novel·la":
        {
          return Color.fromARGB(255, 35, 124, 227);
        }
    }
  }

  static colorByCategoryShelves(String name) {
    switch (name) {
      case "Vull Llegir":
        {
          return Color.fromARGB(255, 194, 250, 255);
        }
      case "Llegint":
        {
          return Color.fromARGB(255, 253, 190, 179);
        }
      case "Llegit":
        {
          return Color.fromARGB(255, 234, 255, 191,);
        }
      default:
        {
          return Color.fromARGB(255, 165, 168, 183);
        }
    }
  }
  static colorByCategoryShelvesByTittle(String name) {
    switch (name) {
      case "Vull Llegir":
        {
          return Color.fromARGB(255, 36, 239, 255);
        }
      case "Llegint":
        {
          return Color.fromARGB(255, 255, 77, 41);
        }
      case "Llegit":
        {
          return Color.fromARGB(255, 185, 255, 44,);
        }
      default:
        {
          return Color.fromARGB(255, 0, 0, 0);
        }
    }
  }
}
