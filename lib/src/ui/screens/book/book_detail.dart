import 'package:book_river/src/model/book.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../api/request_helper.dart';
import '../../../config/routes/navigator_routes.dart';

class BookDetail extends StatefulWidget {
  BookDetail({
    Key? key,
    required int this.bookId,
  }) : super(key: key);

  ///El id que pedimos que nos pasen de la pagina principal
  int bookId;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  bool _isLoading = true;

  ///El objeto del libro detallado
  late Book detailedBookById;

  int? _selectedOption;

  bool _isButtonPressedLlegit = false;
  bool _isButtonPressedVullLlegir = false;
  bool _isButtonPressedLlegint = false;

  Future<void> _bookById() async {
    final data = await RequestProvider().getBookById(widget.bookId);
    detailedBookById = Book.fromJson(data[0]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _bookById();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    num? rating = detailedBookById.avgRating;
    double percentage = rating! / 5;
    return _content(percentage, rating.toDouble());
  }

  _content(double percentage, double rating) {
    return Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            leading: IconButton(icon:Icon(Icons.arrow_back) ,onPressed: () {
              Navigator.pushNamed(context, NavigatorRoutes.mainHolder);
            },),
            backgroundColor: Colors.transparent,
            collapsedHeight: 70,
            surfaceTintColor: Colors.white,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 470.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 244, 242),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    ///TopBar
                    _topBar(percentage, rating),

                    ///Carousel de las imagenes
                    _carouselImage(),
                    const SizedBox(
                      height: 15,
                    ),

                    ///Icons Row
                    _rowButtons(),
                  ],
                ),
              ),
            ),
          ),
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
        floatingActionButton: _cartButton());
  }

  Align _cartButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: () {
          //Provider.of<NavigationNotifier>(context, listen: false).addToCart(detailedBookById);
          final snackBar = SnackBar(
            content: const Text('Libro añadido!'),
            action: SnackBarAction(
              label: 'Ir al carrito',
              onPressed: () {
                Navigator.pushNamed(context, NavigatorRoutes.cartScreen);
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          //print(Provider.of<NavigationNotifier>(context, listen: false).books.length);
        },
        child: Text('A la cistella · ${detailedBookById.price}€'),
      ),
    );
  }

  Row _rowButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  _isButtonPressedVullLlegir = false;
                  _isButtonPressedLlegint = false;
                  _isButtonPressedLlegit = !_isButtonPressedLlegit;
                });
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.bookmark_added,
                color: _isButtonPressedLlegit ? Colors.blue : Colors.cyanAccent,
                size: 35.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(
                side: BorderSide(
                  color:
                      _isButtonPressedLlegit ? Colors.blue : Colors.cyanAccent,
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
                  _isButtonPressedLlegit = false;

                  _isButtonPressedLlegint = false;
                  _isButtonPressedVullLlegir = !_isButtonPressedVullLlegir;
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
                  _isButtonPressedLlegit = false;
                  _isButtonPressedVullLlegir = false;
                  _isButtonPressedLlegint = !_isButtonPressedLlegint;
                });
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.collections_bookmark,
                color:
                    _isButtonPressedLlegint ? Colors.blue : Colors.cyanAccent,
                size: 35.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(
                side: BorderSide(
                  color:
                      _isButtonPressedLlegint ? Colors.blue : Colors.cyanAccent,
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
    );
  }

  CarouselSlider _carouselImage() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: detailedBookById.bookImgs?.map((imgUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.network(
                imgUrl.img!,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/images/portada.jpeg');
                },
              ),
            );
            //imgUrl != null ? Image.network(imgUrl.img!): Image.asset('assets/images/portada.jpeg'));
          },
        );
      }).toList(),
    );
  }

  Row _topBar(double percentage, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 80,
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Text(
                detailedBookById.title!,
                style: TextStyle(color: Colors.black),
              ),
              Text('${detailedBookById.author} · ${detailedBookById.price}€',
                  style: TextStyle(color: Colors.black))
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 5.0, top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NavigatorRoutes.ratingsBook,
                    arguments: detailedBookById);
              },
              child: CircularPercentIndicator(
                radius: 25.0,
                lineWidth: 5.0,
                percent: percentage,
                center: Text(
                  "$rating",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
                progressColor: Colors.yellow,
              ),
            )),
      ],
    );
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
