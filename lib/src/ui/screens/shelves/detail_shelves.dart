import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/pruebas+/book_prueba.dart';

class DetailShelves extends StatefulWidget {
  const DetailShelves({Key? key}) : super(key: key);

  @override
  State<DetailShelves> createState() => _DetailShelvesState();
}

class _DetailShelvesState extends State<DetailShelves> {
  bool isPublic = false;
  List<BookPrueba> books = [
    BookPrueba(
        1,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpg",
        ],
        "Aventura 1",
        "MisCoyo",
        "Aventura",
        "a",
        5,
        5.0),
    BookPrueba(
        2,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpeg"
        ],
        "Aventura 2",
        "Pepe",
        "Aventura",
        "a",
        4,
        4.0),
    BookPrueba(
        3,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpeg"
        ],
        "Aventura 3",
        "Antonio",
        "Fantasia",
        "a",
        6,
        1.0),
    BookPrueba(
        4,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpeg"
        ],
        "Mi cuarto libro",
        "Armando",
        "Fantasia",
        "a",
        1,
        2.0),
    BookPrueba(
        5,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpeg"
        ],
        "Granjero",
        "Julio",
        "Accion",
        "Accion",
        2,
        1.0),
    BookPrueba(
        6,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpeg"
        ],
        "Panadero",
        "Ayahuasca",
        "Accion",
        "Accion",
        3,
        3.0),
    BookPrueba(
        7,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpeg",
          "assets/images/portada2.jpeg"
        ],
        "El ingles se eneseña mal",
        "Martin",
        "Misterio",
        "a",
        10,
        5.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Misteri'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, NavigatorRoutes.editShelves);
            }, icon: Icon(Icons.edit, color: AppColors.secondary,))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Prestatgeria pública'),
                      Switch(
                        activeColor: AppColors.tertiary,
                        value: isPublic,
                        onChanged: (value) {
                          setState(() {
                            isPublic = value;
                            print(isPublic);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Text(
                  'Descripcio',
                  style: TextStyle(color: AppColors.tertiary, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')),
                ),
                Text(
                  'Llibres',
                  style: TextStyle(color: AppColors.tertiary, fontSize: 20),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Image.asset(books[index].img[1]),
                        title: Text(books[index].title),
                        subtitle: Text('Precio: €${books[index].price}'),
                        trailing: CircularPercentIndicator(
                          radius: 20.0,
                          lineWidth: 3.0,
                          percent: books[index].rating / 5,
                          center: Text("${books[index].rating}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                  color: AppColors.secondary)),
                          progressColor: AppColors.secondary,
                        ));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
