import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';

class ShelvesScreen extends StatefulWidget {
  const ShelvesScreen({Key? key}) : super(key: key);

  @override
  State<ShelvesScreen> createState() => _ShelvesScreenState();
}

class _ShelvesScreenState extends State<ShelvesScreen> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
    appBar: _customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: _shelveList(),
      ),
      floatingActionButton: _addButton(context));
  }

  GridView _shelveList() {
    return GridView.builder(
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NavigatorRoutes.detailShelves);
              },
              child: _shelveItem());
        },
      );
  }

  Container _shelveItem() {
    return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
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
  }

  FloatingActionButton _addButton(BuildContext context) {
    return FloatingActionButton.extended(
          backgroundColor: AppColors.secondaryCake,
          onPressed: () {
            Navigator.pushNamed(context, NavigatorRoutes.addShelves);
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
  _customAppBar(BuildContext context){
    return AppBar(
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
    );
  }
}
