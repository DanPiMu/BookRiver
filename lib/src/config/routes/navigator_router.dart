
import 'package:book_river/src/model/book.dart';
import 'package:book_river/src/ui/screens/book/bookDetail.dart';
import 'package:book_river/src/ui/screens/book/listBookCategory.dart';
import 'package:book_river/src/ui/screens/book/ratingBook.dart';
import 'package:book_river/src/ui/screens/book/ratingsBook.dart';
import 'package:book_river/src/ui/screens/book/searchBook.dart';
import 'package:flutter/material.dart';
import '../../ui/screens/book/profileOtherUser.dart';
import '../../ui/screens/inicioScreens/logIn.dart';
import '../../ui/screens/inicioScreens/recuperarContraseñaScreen.dart';
import '../../ui/screens/inicioScreens/singnIn.dart';
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
            return const SignIn();
          },
        );
      case NavigatorRoutes.logIn:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
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
      Book book = settings.arguments as Book;
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
