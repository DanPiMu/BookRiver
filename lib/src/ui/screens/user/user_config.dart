import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../config/app_localizations.dart';
import '../../../config/routes/navigator_routes.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Image.asset(
          "assets/images/fondo_4.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        _content(context)
      ],
    );
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.getString("configuration")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NavigatorRoutes.editProfileScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.getString("edit_profile")),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.secondary,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, NavigatorRoutes.editPasswordScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      AppLocalizations.of(context)!.getString("edit_password")),
                  Icon(Icons.arrow_forward_ios, color: AppColors.secondary)
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await RequestProvider().logOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, NavigatorRoutes.login, (route) => false);
                } on ApiException catch (ae) {
                  ae.printDetails();
                }
              },
              child: Text(AppLocalizations.of(context)!.getString("sign_out")),
            )
          ],
        ),
      ),
    );
  }
}
