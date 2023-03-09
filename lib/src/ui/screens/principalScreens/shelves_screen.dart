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

  @override
  void initState() {
    readResponseShelvesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingShelves) {
      return Center(
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              print('111111111');
              //Navigator.pushNamed(context, NavigatorRoutes.detailShelves);
            },
            child: _shelveItem(index));
      },
    );
  }

  Widget _shelveItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, NavigatorRoutes.detailShelves,
            arguments: _shelvesList[index]);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(_shelvesList[index].img.toString(),
                  fit: BoxFit.cover, errorBuilder: (BuildContext context,
                      Object exception, StackTrace? stackTrace) {
                return Icon(Icons.book);
              }),
              Text(_shelvesList[index].name!),
              Row(
                children: [],
              )
            ],
          ),
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
          'Afegir',
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
    );
  }
}
