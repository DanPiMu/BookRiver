import 'package:book_river/src/model/pruebas+/book_prueba.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/navigator_routes.dart';
import '../../../provider/navigation_notifier.dart';

class BookDetail extends StatefulWidget {
  BookDetail({Key? key, required BookPrueba this.book}) : super(key: key);

  BookPrueba book;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  late List imgC;

  int? _selectedOption;

  bool _isButtonPressedLlegit = false;
  bool _isButtonPressedVullLlegir = false;
  bool _isButtonPressedLlegint = false;

  @override
  void initState() {
    List img = widget.book.img;
    imgC = img.cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    //Porcentaje
    double rating = widget.book.rating;
    double percentage = rating / 5;
    return _content(percentage, rating);
  }
  _content(double percentage, double rating) {
    return Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
          collapsedHeight: 70,
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 500.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text('${widget.book.author} · ${widget.book.price}€',
                      style: TextStyle(color: Colors.black))
                ],
              ),
            ),
            centerTitle: true,
            background: Container(
              decoration: const BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  ///TopBar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding:
                          const EdgeInsets.only(right: 15.0, top: 25),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, NavigatorRoutes.ratingsBook);
                              //me voy a la otra pagina, para ver las valoraciones del libro actual
                            },
                            child: CircularPercentIndicator(
                              radius: 30.0,
                              lineWidth: 9.0,
                              percent: percentage,
                              center: Text(
                                "$rating/5",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              progressColor: Colors.yellow,
                            ),
                          )),
                    ],
                  ),

                  ///Carousel de las imagenes
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imgC.map((imgUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.asset(imgUrl));
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  ///Icons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                _isButtonPressedLlegit =
                                !_isButtonPressedLlegit;
                              });
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Icon(
                              Icons.bookmark_added,
                              color: _isButtonPressedLlegit
                                  ? Colors.blue
                                  : Colors.cyanAccent,
                              size: 35.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(
                              side: BorderSide(
                                color: _isButtonPressedLlegit
                                    ? Colors.blue
                                    : Colors.cyanAccent,
                              ),
                            ),
                          ),
                          Text('Llegit')
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                _isButtonPressedVullLlegir =
                                !_isButtonPressedVullLlegir;
                              });
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Icon(
                              Icons.bookmark_add,
                              color: _isButtonPressedVullLlegir
                                  ? Colors.blue
                                  : Colors.cyanAccent,
                              size: 35.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(
                              side: BorderSide(
                                color: _isButtonPressedVullLlegir
                                    ? Colors.blue
                                    : Colors.cyanAccent,
                              ),
                            ),
                          ),
                          Text('Vull llegir')
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                _isButtonPressedLlegint =
                                !_isButtonPressedLlegint;
                              });
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Icon(
                              Icons.collections_bookmark,
                              color: _isButtonPressedLlegint
                                  ? Colors.blue
                                  : Colors.cyanAccent,
                              size: 35.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(
                              side: BorderSide(
                                color: _isButtonPressedLlegint
                                    ? Colors.blue
                                    : Colors.cyanAccent,
                              ),
                            ),
                          ),
                          Text('Llegint')
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              _showDialog();
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Icon(
                              Icons.read_more,
                              color: Colors.pinkAccent,
                              size: 35.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                          Text('Més')
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
          ,
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sinopsi'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas "Letraset", las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.'),
            ),
          )
        ]),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {

              Provider.of<NavigationNotifier>(context, listen: false)
                  .addToCart(widget.book);
              //print(Provider.of<NavigationNotifier>(context, listen: false).books.length);
            },
            child: Text('A la cistella · ${widget.book.price}€'),
          ),
        ));
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Afegeix aquest llibre a una de les teves prestatgeries'),
          children: <Widget>[
            RadioListTile(
              title: Text('Opción 1'),
              value: 1,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                //Navigator.of(context).pop();
              },
            ),
            RadioListTile(
              title: Text('Opción 2'),
              value: 2,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                //Navigator.of(context).pop();
              },
            ),
            RadioListTile(
              title: Text('Opción 3'),
              value: 3,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                //Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    child: Text('Confirmar'),
                    onPressed: () {
                      Navigator.of(context).pop(_selectedOption);
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
