/// TODO: Modificar rutes
import 'package:book_river/src/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'config/app_styles.dart';
import 'config/routes/navigator_router.dart';
import 'config/routes/navigator_routes.dart';

class BookRiver extends StatefulWidget {
  const BookRiver({super.key});

  @override
  _BookRiver createState() => _BookRiver();
}

class _BookRiver extends State<BookRiver> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample App',
      theme: AppStyles.mainTheme,
      initialRoute: NavigatorRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,


        /*localizationsDelegates: [
        AppLocalizationsDelegate(),
        FallbackCupertinoLocalisationsDelegate(),
        //GlobalMaterialLocalizations.delegate,
        //GlobalWidgetsLocalizations.delegate
      ],*/
      supportedLocales: [
        const Locale('en'),
        //const Locale('es'),
        //const Locale('ca'),
      ],
    );
  }
}
