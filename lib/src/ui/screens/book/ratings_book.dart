import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/routes/navigator_routes.dart';

class RatingsBook extends StatefulWidget {
  const RatingsBook({Key? key}) : super(key: key);

  @override
  State<RatingsBook> createState() => _RatingsBookState();
}

class _RatingsBookState extends State<RatingsBook> {
  @override
  Widget build(BuildContext context) {
    //Porcentaje
    double rating = 1;
    double percentage = rating / 5;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: LayoutBuilder(builder: (context, constraints) {
                return Text(
                  'Valoracions',
                  style: TextStyle(
                    color: constraints.maxHeight > 70
                        ? Color.fromARGB(0, 0, 0, 0)
                        : Colors.black,
                  ),
                );
              }),
              centerTitle: true,
              background: Container(
                  height: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    //Aqui tendre que coger la valoracion del libro
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Valoracions',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/EstrellitaNaranja.png'),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: CircularPercentIndicator(
                                radius: 45.0,
                                lineWidth: 8.0,
                                percent: percentage,
                                center: Text(
                                  "$rating",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: AppColors.secondary),
                                ),
                                progressColor: AppColors.secondary,
                              ),
                            ),
                            Image.asset('assets/images/EstrellitaNaranja.png'),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, NavigatorRoutes.profileOtherUser);
                },
                child: Container(
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
                                Text('Estrellitas'),
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
                ),
              )

              //ListTile(title: Text('Item #$index')),
              // Construye 1000 ListTiles
              ,childCount: 1000,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.secondaryCake,
          onPressed: () {
            Navigator.pushNamed(context, NavigatorRoutes.ratingBook);
          },
          label: Text(
            'Valorar',
            style: TextStyle(color: AppColors.secondary),
          ),
          icon: Icon(
            Icons.star,
            color: AppColors.secondary,
          ),
          elevation: 1),
    );
  }
}
