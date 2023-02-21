
import 'package:book_river/src/model/pruebas+/book_prueba.dart';
import 'package:book_river/src/ui/screens/book/book_detail.dart';
import 'package:book_river/src/ui/screens/book/list_book_category.dart';
import 'package:book_river/src/ui/screens/book/rating_book.dart';
import 'package:book_river/src/ui/screens/book/ratings_book.dart';
import 'package:book_river/src/ui/screens/book/search_book.dart';
import 'package:book_river/src/ui/screens/shelves/add_shelves.dart';
import 'package:book_river/src/ui/screens/shelves/detail_shelves.dart';
import 'package:book_river/src/ui/screens/shelves/edit_shelves.dart';
import 'package:book_river/src/ui/screens/user/edit_password.dart';
import 'package:book_river/src/ui/screens/user/edit_profile.dart';
import 'package:book_river/src/ui/screens/user/user_config.dart';
import 'package:book_river/src/ui/screens/user/user_ratings.dart';
import 'package:flutter/material.dart';
import '../../ui/screens/book/profile_other_user.dart';
import '../../ui/screens/inicioScreens/login.dart';
import '../../ui/screens/inicioScreens/register.dart';
import '../../ui/screens/inicioScreens/forgot_password.dart';
import '../../ui/screens/main_holder.dart';
import 'navigator_routes.dart';

/// Inclou la funció [generateRoute] que ens permetrà generar les rutes de
/// navegació de l'App.
class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigatorRoutes.signIn:
        return MaterialPageRoute(
          builder: (context) {
            return const LogIn();
          },
        );
      case NavigatorRoutes.logIn:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterScreen();
          },
        );
      case NavigatorRoutes.passwordRecovery:
        return MaterialPageRoute(builder: (context) {
          return const PasswordRecoveryScreen();
        });
      case NavigatorRoutes.mainHolder:
        return MaterialPageRoute(builder: (context) {
          return const MainHolder();
        });
      case NavigatorRoutes.bookDetails:
      BookPrueba book = settings.arguments as BookPrueba;
        return MaterialPageRoute(builder: (context){
          return BookDetail(
            book : book,
          );
        });

      case NavigatorRoutes.ratingsBook:
        return MaterialPageRoute(builder: (context){
          return const RatingsBook();
        });

      case NavigatorRoutes.ratingBook:
        return MaterialPageRoute(builder: (context){
          return const RatingBook();
        });

      case NavigatorRoutes.profileOtherUser:
        return MaterialPageRoute(builder: (context){
          return const ProfileOtherUser();
        });

      case NavigatorRoutes.listBookCategory:
        return MaterialPageRoute(builder: (context){
          return const ListBookCategory();
        });

      case NavigatorRoutes.searchBook:
        return MaterialPageRoute(builder: (context){
          return const SearchBook();
        });

      case NavigatorRoutes.addShelves:
        return MaterialPageRoute(builder: (context){
          return const AddNewShelve();
        });

      case NavigatorRoutes.detailShelves:
        return MaterialPageRoute(builder: (context){
          return const DetailShelves();
        });

      case NavigatorRoutes.editShelves:
        return MaterialPageRoute(builder: (context){
          return const EditShelves();
        });

      case NavigatorRoutes.userRatings:
        return MaterialPageRoute(builder: (context){
          return const UserRatings();
        });

      case NavigatorRoutes.userSettings:
        return MaterialPageRoute(builder: (context){
          return const UserSettingsScreen();
        });
      case NavigatorRoutes.editProfileScreen:
        return MaterialPageRoute(builder: (context){
          return const EditProfileScreen();
        });
      case NavigatorRoutes.editPasswordScreen:
        return MaterialPageRoute(builder: (context){
          return const EditPasswordScreen();
        });


      //Ejemplo con argumentos y sin argumentos
      ///
  /*static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch(settings.name) {
      /// Exemple de pantalla sense arguments.
      case NavigatorRoutes.signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn();
          },
        );
      /// Exemple de pantalla amb arguments.
      case NavigatorRoutes.sampleScreen:
        SampleScreenArguments _arguments = settings.arguments as SampleScreenArguments;

        return MaterialPageRoute(
          builder: (context) {
            return SampleScreen(
              name: _arguments.name,
            );
          },
        );
    }
  }*/
    }
  }
}
