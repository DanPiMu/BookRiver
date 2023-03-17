import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
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
      final data = await RequestProvider().getShelves();
      List<dynamic> shelvesListData = data;

      setState(() {
        _shelvesList = shelvesListData
            .map((listData) => Shelves.fromJson(listData))
            .toList();
        print('hecho');
        _isLoadingShelves = false;
      });

      return _shelvesList;
    } on ApiException catch (ae) {
      ae.printDetails();
      SnackBar(content: Text(ae.message!));
      rethrow;
    } catch (e) {
      print('Problemillas');
      rethrow;
    }
  }

  Future<void> _myUser() async {
    try {
      final data = await RequestProvider().getUser();
      myUser = User.fromJson(data);
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
          'Valoracions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: Icon(
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
                  : Icons.book_outlined, // icono de estanteria creada
            ),
            Text(_shelvesList[index].name!),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _shelvesList[index].books.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
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
          Container(
            height: 150,
            width: 150,
            child: Image.network(
              myUser.userImg.toString(),
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pepe.jpeg'),
                );
              },
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "@${myUser.username}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                Icon(Icons.mail, color: AppColors.secondary),
                Text(myUser.email.toString())
              ],
            ),
            Row(
              children: [
                Icon(Icons.cake, color: AppColors.secondary),
                myUser.birthDate == null
                    ? Text('----')
                    : Text(myUser.birthDate.toString())
              ],
            )
          ])
        ],
      ),
    );
  }

  _customAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          children: [
            Image.asset(
              "assets/images/BookRiver_logo_horizontal.png",
              height: 30,
              width: 150,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NavigatorRoutes.userSettings);
            },
            icon: Icon(
              Icons.settings,
              color: AppColors.secondary,
            ))
      ],
    );
  }
}
