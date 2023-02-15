import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/config/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/navigation_notifier.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationNotifier>(context);
    return BottomNavigationBar(
      elevation: 20,
      unselectedLabelStyle: TextStyle(color: Colors.black),
        iconSize: 30,
        fixedColor: AppColors.tertiary,

        currentIndex: navigationProvider.selectedOption.index,
        onTap: (int index) {
          navigationProvider.selectedOption = NavigationOption.values[index];
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.book, color: AppColors.tertiary),
              label: 'Inici'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_rounded, color: AppColors.tertiary),
              label: 'Prestatgeries'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: AppColors.tertiary),
              label: 'Cistella'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: AppColors.tertiary),
              label: 'Perfil'),
        ]);
  }
}
