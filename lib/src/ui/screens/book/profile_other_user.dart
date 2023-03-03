import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileOtherUser extends StatefulWidget {
  const ProfileOtherUser({Key? key}) : super(key: key);

  @override
  State<ProfileOtherUser> createState() => _ProfileOtherUserState();
}

class _ProfileOtherUserState extends State<ProfileOtherUser> {
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
          Container(
            child: Image.asset(
              "assets/images/fondo_3.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          _content()
        ],
      )
      ;
  }

  Scaffold _content() {
    return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
              backgroundColor: AppColors.transparent
          ),
          body: Container(
            //color: Colors.transparent,
            child: Column(
              children: [
                ///User photo
                _userInfo(),
                ///Prestatgeries
                _userShelves()
              ],
            ),
          ),
        );
  }

  SizedBox _userInfo() {
    return SizedBox(
                height: 220,
                //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Center(
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('@Username', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  ),
                ],
              ),
              );
  }

  Expanded _userShelves() {
    return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:15, right:15),
                    child: GridView.builder(
                      //physics: NeverScrollableScrollPhysics(),
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

}
