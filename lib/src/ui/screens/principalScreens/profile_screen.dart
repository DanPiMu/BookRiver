import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/navigator_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            "assets/images/fondo_5.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          _content(context)
        ],
      )
      ;
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.transparent,
            appBar: _customAppBar(context),
            body: Column(
              children: [
                _userInfo(),
                _shelvesList()
              ],
            ),
            floatingActionButton: _ratingButton(context));
  }

  FloatingActionButton _ratingButton(BuildContext context) {
    return FloatingActionButton.extended(
              backgroundColor: AppColors.secondary,
              onPressed: () {
                Navigator.pushNamed(context, NavigatorRoutes.userRatings);
              },
              label: Text(
                'Valoracions',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              icon: Icon(
                Icons.star,
                color: Colors.white,
              ),
              elevation: 1);
  }

  Expanded _shelvesList() {
    return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:15, right:15),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.blue,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.ac_unit),
                                Text('data'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ));
  }

  Padding _userInfo() {
    return Padding(
                padding: const EdgeInsets.only(top:30.0, bottom:30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          border:Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text('@Nombre Usuario'),
                          Row(
                            children: [
                              Icon(Icons.mail, color:AppColors.secondary),
                              Text('correo user')
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.cake, color:AppColors.secondary),
                              Text('Fecha de cumpleaños')
                            ],
                          )
                        ]
                    )
                  ],
                ),
              );
  }
  _customAppBar(BuildContext context){
    return AppBar(
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          children: [
            Image.asset(
              "assets/images/BookRiver_logo_horizontal.png",height: 30, width: 150,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: (){

          Navigator.pushNamed(context, NavigatorRoutes.userSettings);
        }, icon: Icon(Icons.settings, color: AppColors.secondary,))
      ],
    );
  }
}
