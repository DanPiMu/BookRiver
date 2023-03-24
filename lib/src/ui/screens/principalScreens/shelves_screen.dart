import 'package:book_river/src/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/shelves.dart';

class ShelvesScreen extends StatefulWidget {
  const ShelvesScreen({Key? key}) : super(key: key);

  @override
  State<ShelvesScreen> createState() => _ShelvesScreenState();
}

class _ShelvesScreenState extends State<ShelvesScreen> {
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
    readResponseShelvesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingShelves) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return _content(context);
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
        appBar: _customAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: _shelveList(),
        ),
        floatingActionButton: _addShelvesButton(context));
  }

  GridView _shelveList() {
    return GridView.builder(
      //physics: NeverScrollableScrollPhysics(),
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
    );
  }

  Widget _shelveItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, NavigatorRoutes.detailShelves,
                arguments: _shelvesList[index])
            .then((value) => {
                  setState(() => ({readResponseShelvesList()}))
                });
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
                color: AppColors.colorByCategoryShelvesByTittle(
                    _shelvesList[index].name!)),
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

  FloatingActionButton _addShelvesButton(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: AppColors.secondaryCake,
        onPressed: () {
          Navigator.pushNamed(context, NavigatorRoutes.addShelves).then((_) {
            setState(() {
              readResponseShelvesList();
            });
          });
        },
        label: Text(
          AppLocalizations.of(context)!.getString('add'),
          style: TextStyle(
              color: AppColors.secondary, fontWeight: FontWeight.bold),
        ),
        icon: Icon(
          Icons.add,
          color: AppColors.secondary,
        ),
        elevation: 1);
  }

  _customAppBar(BuildContext context) {
    return AppBar(
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
    );
  }
}
