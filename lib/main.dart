import 'package:book_river/src/app.dart';
import 'package:book_river/src/provider/navigation_notifier.dart';
import 'package:book_river/src/utils/user_helper_plantilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// TODO: Descomntar en cas de fer servir UserHelper (preguntar a altre front).

  try {
    /// Obtenir usuari de shared preferences
    await UserHelper.getUserDataFromSharedPreferences();
  } catch(e, s) {
    print("ERROR start $e");
    print("ERROR start $s");
  }


//AppLocalizations.of(context).getString("value");
  /// Ens assegurem que l'app sempre es mostri en PORTRAIT.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);


    runApp(
      MultiProvider(providers: [ChangeNotifierProvider<NavigationNotifier>(create: (_)=> NavigationNotifier())],
      child: const BookRiver(),)

    );
  });

}
