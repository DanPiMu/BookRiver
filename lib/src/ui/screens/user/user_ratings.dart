import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class UserRatings extends StatefulWidget {
  const UserRatings({Key? key}) : super(key: key);

  @override
  State<UserRatings> createState() => _UserRatingsState();
}

class _UserRatingsState extends State<UserRatings> {
  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Scaffold _content() {
    return Scaffold(
    appBar: AppBar(
      title: Text('Valoracions'),
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: ListView.builder(itemCount: 5, itemBuilder: (BuildContext context, int index){
        return _ratingItem(index);
      }),
    ),
  );
  }

  Container _ratingItem(int index) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              color: Colors.green,
            ),
            Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //nombre de el usuario
                      Text('Item #$index'),
                      Row(
                        children: [
                          Text('Libro valorado', style:TextStyle(
                            color: AppColors.tertiary
                          )),
                          SizedBox(width: 20,),
                          Text('Estrellitas'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó '),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      );
  }
}
