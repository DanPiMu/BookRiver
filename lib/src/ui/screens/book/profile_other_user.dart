import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_localizations.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/User.dart';

class ProfileOtherUser extends StatefulWidget {
  ProfileOtherUser({Key? key, required this.userID}) : super(key: key);

  int userID;

  @override
  State<ProfileOtherUser> createState() => _ProfileOtherUserState();
}

class _ProfileOtherUserState extends State<ProfileOtherUser> {
  bool _isLoading = true;

  late User publicUser;

  Future<void> _otherUserById() async {
    try {
      publicUser = await RequestProvider().getOtheruser(widget.userID);

      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta saltando la apiExeption${ae.message!}'),
      ));
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
        Image.asset(
          "assets/images/fondo_3.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
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
      body: Column(
        children: [
          ///User photo
          _userInfo(),

          ///Prestatgeries
          _userShelves()
        ],
      ),
        floatingActionButton: _ratingButton(context));
  }

  FloatingActionButton _ratingButton(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        onPressed: () {


          Navigator.pushNamed(context, NavigatorRoutes.userRatings,
              arguments: publicUser);
        },
        label: Text(
          AppLocalizations.of(context)!.getString('ratings'),
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.star,
          color: Colors.white,
        ),
        elevation: 1);
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
                    return const CircleAvatar(
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
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
          ? const Text(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                color: AppColors.colorByCategoryShelvesByTittle(
                    publicUser.libraries[index].name!)),
            Text(publicUser.libraries[index].name!,
                style: TextStyle(
                    fontFamily: 'Abril Fatface',
                    color: AppColors.colorByCategoryShelvesByTittle(
                        publicUser.libraries[index].name!))),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: publicUser.libraries[index].books.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
