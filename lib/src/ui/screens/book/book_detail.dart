import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/config/enums.dart';
import 'package:book_river/src/model/book.dart';
import 'package:book_river/src/model/shelves.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_localizations.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../provider/navigation_notifier.dart';

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
  bool _isLoadingShelves = true;

  ///El objeto del libro detallado
  late Book detailedBookById;

  int? idShelves;

  List<Shelves> _shelvesList = [];

  Future<List<Shelves>> readResponseShelvesList() async {
    try {
      final data = await RequestProvider().getShelves();
      List<dynamic> shelvesListData = data;

      setState(() {
        _shelvesList = shelvesListData
            .map((listData) => Shelves.fromJson(listData))
            .toList();
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

  Future<void> _bookById() async {
    try {
      final data = await RequestProvider().getBookById(widget.bookId);
      detailedBookById = Book.fromJson(data);
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _addBookToShelves() async {
    try {
      await RequestProvider().postShelvesBook(widget.bookId, idShelves!);
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context)!.getString(ae.message ?? "rc_1")),
      ));
      rethrow;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('salta el catch'),
      ));
      print('Problemillas');
      rethrow;
    }
  }

  bool _inTheLibrary() {
    bool bookFound = true;
    for (Book book in _shelvesList[0].books) {
      if (book.id == detailedBookById.id) {
        return true;
      }
      bookFound = false;
    }
    return bookFound;
  }

  bool _inTheLibrary1() {
    bool bookFound = true;
    for (Book book in _shelvesList[1].books) {
      if (book.id == detailedBookById.id) {
        return true;
      }
      bookFound = false;
    }
    return bookFound;
  }

  bool _inTheLibrary2() {
    bool bookFound = true;
    for (Book book in _shelvesList[2].books) {
      if (book.id == detailedBookById.id) {
        return true;
      }
      bookFound = false;
    }
    return bookFound;
  }

  @override
  void initState() {
    super.initState();
    _bookById();
    readResponseShelvesList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _isLoadingShelves) {
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
            backgroundColor: Colors.transparent,
            collapsedHeight: 70,
            surfaceTintColor: Colors.white,
            pinned: false,
            snap: false,
            floating: true,
            expandedHeight: 470.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: detailedBookById.categories.isEmpty
                      ? AppColors.defaultCategoryColor
                      : AppColors.colorByCategoryBG(
                          detailedBookById.categories[0].nameEs!),
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
                    _rowShelvesButtons(),
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
                child: Text(detailedBookById.description!)),
          ),
        ]),
        floatingActionButton: _cartButton());
  }

  Widget _cartButton() {
    final navigationProvider = Provider.of<NavigationNotifier>(context);
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            Provider.of<NavigationNotifier>(context, listen: false)
                .addToCart(detailedBookById);
            final snackBar = SnackBar(
              content: const Text('Libro añadido!'),
              action: SnackBarAction(
                label: 'Ir al carrito',
                onPressed: () {
                  Navigator.pop(context);
                  navigationProvider.selectedOption = NavigationOption.Cistella;
                  //Navigator.pushNamed(context, NavigatorRoutes.cartScreen);
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            //print(Provider.of<NavigationNotifier>(context, listen: false).books.length);
          },
          child: Text(
              '${AppLocalizations.of(context)!.getString('to_cart')} · ${detailedBookById.price}€'),
        ),
      ),
    );
  }

  Row _rowShelvesButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            RawMaterialButton(
              onPressed: () {
                idShelves = _shelvesList[2].id;
                _addBookToShelves();
                setState(() {
                  readResponseShelvesList();
                  _inTheLibrary2();
                });
              },
              elevation: 2.0,
              fillColor: Colors.white,
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(
                side: BorderSide(
                  color: _inTheLibrary2() ? Colors.blue : Colors.cyanAccent,
                ),
              ),
              child: Icon(
                Icons.bookmark_added,
                color: _inTheLibrary2() ? Colors.blue : Colors.cyanAccent,
                size: 35.0,
              ),
            ),
            Text(AppLocalizations.of(context)!.getString('read'))
          ],
        ),
        Column(
          children: [
            RawMaterialButton(
              onPressed: () {
                idShelves = _shelvesList[0].id;
                _addBookToShelves();

                setState(() {
                  readResponseShelvesList();
                  _inTheLibrary();
                });
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.bookmark_add,
                color: _inTheLibrary() ? Colors.blue : Colors.cyanAccent,
                size: 35.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(
                side: BorderSide(
                  color: _inTheLibrary() ? Colors.blue : Colors.cyanAccent,
                ),
              ),
            ),
            Text(AppLocalizations.of(context)!.getString('wanna_read'))
          ],
        ),
        Column(
          children: [
            RawMaterialButton(
              onPressed: () {
                idShelves = _shelvesList[1].id;
                _addBookToShelves();

                setState(() {
                  readResponseShelvesList();
                  _inTheLibrary1();
                });
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.collections_bookmark,
                color: _inTheLibrary1() ? Colors.blue : Colors.cyanAccent,
                size: 35.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(
                side: BorderSide(
                  color: _inTheLibrary1() ? Colors.blue : Colors.cyanAccent,
                ),
              ),
            ),
            Text(AppLocalizations.of(context)!.getString('reading'))
          ],
        ),
        Column(
          children: [
            RawMaterialButton(
              onPressed: () {
                _showDialog(_shelvesList);
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
            Text(AppLocalizations.of(context)!.getString('more'))
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
              width: 220,
              //width: MediaQuery.of(context).size.width,
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

  Widget _topBar(double percentage, double rating) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 10),
            child: Column(
              children: [
                Text(
                  detailedBookById.title!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Abril Fatface'),
                ),
                Text('${detailedBookById.author} · ${detailedBookById.price}€',
                    style: TextStyle(color: Colors.black))
              ],
            ),
          ),
          Positioned(
            right: 10,
            child: Padding(
                padding: const EdgeInsets.only(right: 5.0, top: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NavigatorRoutes.ratingsBook,
                        arguments: detailedBookById.id);
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
          ),
        ],
      ),
    );
  }

  _showDialog(List<Shelves> shelvesList) {
    List<Shelves> _shelvesListSublist = shelvesList.sublist(3);
    Shelves? pres;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Afegeix un daquest llibres a un de les teves prestatgeries',
                style: TextStyle(fontSize: 15),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    _shelvesListSublist.length,
                    (index) => RadioListTile(
                      groupValue: pres,
                      title: Text(_shelvesListSublist[index].name.toString()),
                      value: _shelvesListSublist[index],
                      selected: pres == _shelvesListSublist[index],
                      activeColor: AppColors.tertiary,
                      onChanged: (value) {
                        print("$value");
                        setState(() {
                          pres = value!;
                          print(pres?.name);
                        });
                      },
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    idShelves = pres!.id;
                    _addBookToShelves();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
