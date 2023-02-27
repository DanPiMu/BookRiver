import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/config/routes/navigator_routes.dart';
import 'package:book_river/src/model/book.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';
import '../../../model/pruebas+/book_prueba.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {

  List <dynamic>_booksNovetats = [];
  List<Book> _booksNovetatsList =[];

  Future<void> readResponseBooks()async{
    final data = await RequestProvider().getBooks();
    print('Aqui printamos data${data.toString()}');

    List<dynamic> bookListData = data['data']['books'];
    _booksNovetatsList = bookListData.map((bookData) => Book.fromJson(bookData)).toList();

    print(_booksNovetatsList.length);

  }

  List<BookPrueba> bookList = [
    BookPrueba(
        1,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg",
        ],
        "Aventura 1",
        "MisCoyo",
        "Aventura",
        "a",
        1,
        1.0),
    BookPrueba(
        2,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "Aventura 2",
        "Pepe",
        "Aventura",
        "a",
        1,
        1.0),
    BookPrueba(
        3,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "Aventura 3",
        "Antonio",
        "Fantasia",
        "a",
        1,
        1.0),
    BookPrueba(
        4,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "Mi cuarto libro",
        "Armando",
        "Fantasia",
        "a",
        1,
        1.0),
    BookPrueba(
        5,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "Granjero",
        "Julio",
        "Accion",
        "Accion",
        1,
        1.0),
    BookPrueba(
        6,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "Panadero",
        "Ayahuasca",
        "Accion",
        "Accion",
        1,
        1.0),
    BookPrueba(
        7,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "El ingles se eneseña mal",
        "Martin",
        "Misterio",
        "a",
        1,
        1.0),
  ];

  final List<Map<String, dynamic>> bookCategories = [
    {
      'name': 'Novelas',
      'books': [
        'Cien años de soledad',
        'Matar a un ruiseñor',
        'El Gran Gatsby'
      ],
      'description':
          'Libros que cuentan una historia ficticia con personajes imaginarios.',
      'imageUrl':
          'https://images.unsplash.com/photo-1533777324535-a8a01db96b34',
    },
    {
      'name': 'Ciencia Ficción',
      'books': ['1984', 'Dune', 'Foundation'],
      'description':
          'Libros que describen un mundo imaginario que difiere de la realidad.',
      'imageUrl': 'https://images.unsplash.com/photo-1544511916-0148ccdeb877',
    },
    {
      'name': 'Terror',
      'books': ['El Exorcista', 'Psycho', 'It'],
      'description':
          'Libros que describen eventos y situaciones que causan miedo, terror o sufrimiento.',
      'imageUrl':
          'https://images.unsplash.com/photo-1472289065668-ce650ac443d2',
    },
    {
      'name': 'Comedia',
      'books': ['La naranja mecánica', 'Loco y estupido amor', 'Superbad'],
      'description': 'Libros que describen situaciones cómicas o graciosas.',
      'imageUrl':
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
    },
  ];

  @override
  void initState() {
    readResponseBooks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    return Scaffold(
        appBar: _customAppBar(context, readResponseBooks()),
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Novetats'),
            _novetatsList(),
            const SizedBox(
              height: 10,
            ),
            const Text('Categories'),
            _carouselCategories(),
          ],
      ),
        ));
  }

  _novetatsList() {
    return Container(
        height: 280,
        child: ListView.builder(
          itemCount: _booksNovetatsList.length,
          itemBuilder: (context, index) {
            return _bookItem(_booksNovetatsList[index], context);
          },
          scrollDirection: Axis.horizontal,
        ));
  }

  _carouselCategories() {
    return CarouselSlider.builder(
      itemCount: bookCategories.length,
      itemBuilder: (BuildContext context, int index, int a) {
        return GestureDetector(onTap: (){
          Navigator.pushNamed(context, NavigatorRoutes.listBookCategory);
        },
        child:Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  bookCategories[index]['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              //Text(bookCategories[index]['description']),
              Expanded(
                child: ListView.builder(
                  itemCount: bookCategories[index]['books'].length,
                  itemBuilder: (BuildContext context, int bookIndex) {
                    return ListTile(
                      title: Text(bookCategories[index]['books'][bookIndex]),
                    );
                  },
                ),
              ),
            ],
          ),
        ) ,);

      },
      options: CarouselOptions(
        height: 240,
        viewportFraction: 1.0,
        aspectRatio: 1.5,
        enlargeCenterPage: true,
      ),
    );
  }
}

_customAppBar(BuildContext context, Future<void> readResponseBooks){
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
    actions: [
      IconButton(onPressed: (){

        readResponseBooks;
        //Navigator.pushNamed(context, NavigatorRoutes.searchBook);
      }, icon: Icon(Icons.search, color: AppColors.secondary,))
    ],
  );
}

_bookItem(Book book, BuildContext context) {
  return GestureDetector(
      onTap: () {
        print(book);
        Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
            arguments: book);
      },
      child: Card(
        child: Column(
          children: [
            ///imagen
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 120,
                height: 180,
                child: Image.asset(
                  'assets/images/portada.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  book.author!,
                  style: const TextStyle(fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /*child: image != null
                  ? Image.file(image!, height: 100, width: 100)
                  : Container(
                      decoration: BoxDecoration(color: Colors.red[200]),
                      width: 200,
                      height: 200,
                      child: Image.asset("assets/icons/pepe.jpeg")),*/
                    Text(
                      book.categories![0].nameEs.toString()
                      ,style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text('${book.price.toString()}€')
                  ],
                )
              ],
            ),
          ],
        ),
      ));
}
