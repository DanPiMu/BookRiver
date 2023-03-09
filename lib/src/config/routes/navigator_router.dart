
import 'package:book_river/src/model/User.dart';
import 'package:book_river/src/model/ratings.dart';
import 'package:book_river/src/ui/screens/book/rating_book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/book.dart';
import '../../model/categories.dart';
import '../../model/shelves.dart';
import '../../ui/screens/book/book_detail.dart';
import '../../ui/screens/book/list_book_category.dart';
import '../../ui/screens/book/profile_other_user.dart';
import '../../ui/screens/book/ratings_book.dart';
import '../../ui/screens/book/search_book.dart';
import '../../ui/screens/inicioScreens/forgot_password.dart';
import '../../ui/screens/inicioScreens/login.dart';
import '../../ui/screens/inicioScreens/register.dart';
import '../../ui/screens/main_holder.dart';
import '../../ui/screens/principalScreens/cart_screen.dart';
import '../../ui/screens/shelves/add_shelves.dart';
import '../../ui/screens/shelves/detail_shelves.dart';
import '../../ui/screens/shelves/edit_shelves.dart';
import '../../ui/screens/user/edit_password.dart';
import '../../ui/screens/user/edit_profile.dart';
import '../../ui/screens/user/user_config.dart';
import '../../ui/screens/user/user_ratings.dart';
import 'navigator_routes.dart';

/// Inclou la funció [generateRoute] que ens permetrà generar les rutes de
/// navegació de l'App.
class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {


      case NavigatorRoutes.login:
        return MaterialPageRoute(
          builder: (context) {
            return const LogIn();
          },
        );
      case NavigatorRoutes.register:
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
      Book bookId = settings.arguments as Book;
        return MaterialPageRoute(builder: (context){
          return BookDetail(
             bookId: bookId.id!
          );
        });

      case NavigatorRoutes.ratingsBook:
      Book bookId = settings.arguments as Book;
        return MaterialPageRoute(builder: (context){
          return RatingsBook(
            bookId: bookId.id!
          );
        });

      case NavigatorRoutes.ratingBook:
      Book bookRatings = settings.arguments as Book;
        return MaterialPageRoute(builder: (context){
          return RatingBook(
            bookRating : bookRatings,
          );
        });

      case NavigatorRoutes.profileOtherUser:
        User userID = settings.arguments as User;
        return MaterialPageRoute(builder: (context){
          return ProfileOtherUser(
            userID: userID.id!
          );
        });

      case NavigatorRoutes.listBookCategory:
        Categories bookIdCategory = settings.arguments as Categories;
        return MaterialPageRoute(builder: (context){
          return ListBookCategory(
            bookIdCategory: bookIdCategory.id!
          );
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
        Shelves shelvesId = settings.arguments as Shelves;
        return MaterialPageRoute(builder: (context){
          return DetailShelves(
            shelvesId: shelvesId.id!,
          );
        });

      case NavigatorRoutes.editShelves:
        Shelves shelvesId = settings.arguments as Shelves;
        return MaterialPageRoute(builder: (context){
          return EditShelves(
            shelvesId: shelvesId
          );
        });

      case NavigatorRoutes.userRatings:
        User user = settings.arguments as User;
        return MaterialPageRoute(builder: (context){
          return UserRatings(
            user: user
          );
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

      case NavigatorRoutes.cartScreen:
        return MaterialPageRoute(builder: (context){
          return const CartScreen();
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
