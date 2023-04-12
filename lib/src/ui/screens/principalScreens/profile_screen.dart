import 'dart:io';

import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_localizations.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/User.dart';
import '../../../model/shelves.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User myUser;

  bool _isLoading = true;
  bool _isLoadingShelves = true;

  List<Shelves> _shelvesList = [];

  Future<List<Shelves>> readResponseShelvesList() async {
    try {
      _shelvesList = await RequestProvider().getShelves();

      setState(() {
        _isLoadingShelves = false;
      });

      return _shelvesList;
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.getString(ae.message ?? "rc_1"))));
      rethrow;
    } catch (e) {
      print('Problemillas');
      rethrow;
    }
  }

  Future<void> _myUser() async {
    try {
      myUser = await RequestProvider().getUser();

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

  //edit image user
  File? image;

  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        print('asectado');
        _updateUserPhoto();
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        print('asectado');
        _updateUserPhoto();
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<bool> _updateUserPhoto() async {
    try {
      bool aux = await RequestProvider.updateUserPhoto(image!);
      resetState();
      return aux;
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.getString(ae.message ?? "rc_1"))));
    }
    return false;
  }

  void resetState() {
    _myUser();
    readResponseShelvesList();
  }

  @override
  void initState() {
    _myUser();
    readResponseShelvesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _isLoadingShelves) {
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
          "assets/images/fondo_5.png",
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
        appBar: _customAppBar(context),
        body: Column(
          children: [_userInfo(), _myShelvesList()],
        ),
        floatingActionButton: _ratingButton(context));
  }

  FloatingActionButton _ratingButton(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        onPressed: () {
          Navigator.pushNamed(context, NavigatorRoutes.userRatings,
              arguments: myUser);
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

  Expanded _myShelvesList() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _shelvesList.length,
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
      onTap: () {
        Navigator.pushNamed(context, NavigatorRoutes.detailShelves,
            arguments: _shelvesList[index]);
      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_shelvesList[index].img!),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          color: AppColors.colorByCategoryShelves(_shelvesList[index].name!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 50,
              _shelvesList[index].name == 'Vull Llegir' ||
                      _shelvesList[index].name == 'Llegint' ||
                      _shelvesList[index].name == 'Llegit'
                  ? Icons.book_sharp // icono de estanteria predefinida
                  : Icons.personal_injury, // icono de estanteria creada
              color: AppColors.colorByCategoryShelvesByTittle(
                  _shelvesList[index].name!),
            ),
            Text(
              _shelvesList[index].name!,
              style: TextStyle(
                  fontFamily: 'Abril Fatface',
                  color: AppColors.colorByCategoryShelvesByTittle(
                      _shelvesList[index].name!)),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _shelvesList[index].books.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                              _shelvesList[index]
                                  .books[index1]
                                  .caratula![0]
                                  .img!,
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

  Padding _userInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        bottom: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //imagen perfil
          GestureDetector(
            onTap: () {
              _showMyDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: SizedBox(
                height: 150,
                width: 150,
                child: ClipOval(
                  child: Image.network(
                    myUser.userImg.toString(),
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
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "@${myUser.username}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.mail, color: AppColors.secondary),
                  ),
                  Expanded(
                      child: Text(
                    myUser.email.toString(),
                    softWrap: true,
                  ))
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.cake, color: AppColors.secondary),
                  ),
                  myUser.birthDate == null
                      ? const Text('----')
                      : Text(myUser.birthDate.toString())
                ],
              )
            ]),
          )
        ],
      ),
    );
  }

  _customAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            "assets/images/BookRiver_logo_horizontal.png",
            height: 30,
            width: 150,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NavigatorRoutes.userSettings)
                  .then((_) => {
                        setState(() => {_myUser()})
                      });
            },
            icon: Icon(
              Icons.settings,
              color: AppColors.secondary,
            ))
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.getString('select_image')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.getString('choose_image')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.getString('gallery')),
              onPressed: () {
                pickImage();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.getString('camera')),
              onPressed: () {
                pickImageC();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
