import 'package:flutter/material.dart';

import '../../../config/routes/navigator_routes.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuració'),
        centerTitle: true,
      ),
      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
            onTap: (){
              print('1');
              Navigator.pushNamed(context, NavigatorRoutes.editProfileScreen);

            },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Editar perfil'),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            )
            ,
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                print('2');
                Navigator.pushNamed(context, NavigatorRoutes.editPasswordScreen);
              },
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Canviar contrasenya'),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            )
            ,
            Container(
              child: TextButton(
                onPressed: () {},
                child: Text('Tancar Sessió'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
