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

          _content(percentage, rating, context)
        ],
      )
      ;
  }

  Scaffold _content(double percentage, double rating, BuildContext context) {
    return Scaffold(
          backgroundColor: AppColors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.transparent,
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
                    background: _appBarCustom(percentage, rating)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, NavigatorRoutes.profileOtherUser);
                    },
                    child: _ratingUserItem(index),
                      ),
                  childCount: 1000,
                ),
              ),
            ],
          ),
          floatingActionButton: _ratingButton(context),
        );
  }

  FloatingActionButton _ratingButton(BuildContext context) {
    return FloatingActionButton.extended(
            backgroundColor: AppColors.secondaryCake,
            onPressed: () {
              print('apretado');
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
            elevation: 1);
  }

  Container _ratingUserItem(int index) {
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
                  );
  }

  SizedBox _appBarCustom(double percentage, double rating) {
    return SizedBox(
                      height: 200,
                
                      child: Center(
                      
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
                                Image.asset(
                                    'assets/images/EstrellitaNaranja.png'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
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
                                Image.asset(
                                    'assets/images/EstrellitaNaranja.png'),
                              ],
                            )
                          ],
                        ),
                      ));
  }
}
