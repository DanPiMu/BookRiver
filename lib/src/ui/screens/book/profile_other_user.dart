import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/User.dart';

class ProfileOtherUser extends StatefulWidget {
  ProfileOtherUser({Key? key, required int this.userID}) : super(key: key);

  int userID;

  @override
  State<ProfileOtherUser> createState() => _ProfileOtherUserState();
}

class _ProfileOtherUserState extends State<ProfileOtherUser> {
  bool _isLoading = true;

  late User publicUser;

  Future<void> _otherUserById() async {
    try {
      final data = await RequestProvider().getOtheruser(widget.userID);
      publicUser = User.fromJson(data);
      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (ae) {
      ae.printDetails();
      SnackBar(content: Text(ae.message!));
      rethrow;
    } catch (e) {
      print('Problemillas');
      rethrow;
    }
  }

  @override
  void initState() {
    _otherUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
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
    );
  }

  Scaffold _content() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: AppColors.transparent),
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
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Container(
                height: 160,
                width: 160,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: Image.network(
                  publicUser.userImg.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return CircleAvatar(
                      backgroundImage: AssetImage('assets/images/pepe.jpeg'),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '@${publicUser.username!}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _userShelves() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: publicUser.libraries.isEmpty
          ? Text(
              'No tiene librerias publicas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),
            )
          : GridView.builder(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: publicUser.libraries.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemBuilder: (context, index) {
                return _shelveItem(index);
              },
            ),
    ));
  }

  Widget _shelveItem(int index) {
    return GestureDetector(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(publicUser.libraries[index].img!),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          color: AppColors.colorByCategoryShelves(
              publicUser.libraries[index].name!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 50,
              publicUser.libraries[index].name == 'Vull Llegir' ||
                      publicUser.libraries[index].name == 'Llegint' ||
                      publicUser.libraries[index].name == 'Llegit'
                  ? Icons.book_sharp // icono de estanteria predefinida
                  : Icons.book_outlined, // icono de estanteria creada


                color: AppColors.colorByCategoryShelvesByTittle(publicUser.libraries[index].name!)),
            Text(publicUser.libraries[index].name!, style: TextStyle(fontFamily: 'Abril Fatface',
                color: AppColors.colorByCategoryShelvesByTittle(publicUser.libraries[index].name!))),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: publicUser.libraries[index].books.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                              publicUser.libraries[index].books[index1]
                                  .caratula![0].img!,
                              fit: BoxFit.cover, errorBuilder:
                                  (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
                            return Image.asset('assets/images/portada.jpeg');
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
