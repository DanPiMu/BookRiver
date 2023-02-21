import 'package:book_river/src/provider/navigation_notifier.dart';
import 'package:book_river/src/ui/screens/principalScreens/cart_screen.dart';
import 'package:book_river/src/ui/screens/principalScreens/profile_screen.dart';
import 'package:book_river/src/ui/screens/principalScreens/shelves_screen.dart';
import 'package:book_river/src/ui/screens/principalScreens/starting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/enums.dart';
import '../widgets/navigationBar.dart';

class MainHolder extends StatelessWidget {
  const MainHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationNotifier>(context);
    return Scaffold(
      body:_buildBody(navigationProvider.selectedOption),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

///Aqui añadimos las pantallas que necesiten NavBar
Widget _buildBody(NavigationOption selectedOption) {
  switch( selectedOption){
    case NavigationOption.Inici:
      return const StartingScreen();
    case NavigationOption.Prestatgeries:
      return const ShelvesScreen();
    case NavigationOption.Perfil:
      return const ProfileScreen();
    case NavigationOption.Cistella:
      return const CartScreen();
    default:
      return Container();
  }
}
