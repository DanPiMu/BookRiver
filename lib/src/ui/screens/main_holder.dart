import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/config/routes/navigator_routes.dart';
import 'package:book_river/src/provider/navigation_notifier.dart';
import 'package:book_river/src/ui/screens/principalScreens/startingScreen.dart';
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
      appBar: _customAppBar(context),

      body:_buildBody(navigationProvider.selectedOption),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
_customAppBar(BuildContext context){
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      child: Row(
        children: [
          Image.asset(
            "assets/images/AppbarText.png",
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
    actions: [
      IconButton(onPressed: (){
        Navigator.pushNamed(context, NavigatorRoutes.searchBook);
      }, icon: Icon(Icons.search, color: AppColors.secondary,))
    ],
  );
}

///Aqui añadimos las pantallas que necesiten NavBar
Widget _buildBody(NavigationOption selectedOption) {
  switch( selectedOption){
    case NavigationOption.Inici:
      return const StartingScreen();
    default:
      return Container();
  }
}
