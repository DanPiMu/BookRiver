import 'package:book_river/src/api/api_exception.dart';
import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/model/book.dart';
import 'package:book_river/src/model/categories.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/pruebas+/book_prueba.dart';

class ListBookCategory extends StatefulWidget {
   ListBookCategory({Key? key,
     required int this.bookIdCategory,
   }) : super(key: key);

   int bookIdCategory;


  @override
  State<ListBookCategory> createState() => _ListBookCategoryState();
}

class _ListBookCategoryState extends State<ListBookCategory> {

  bool _isLoading = true;

  List<Book> _bookListByCategory =[];

  Future<void> readResponseBookList () async {
    try{
      final data = await RequestProvider().getBookListByCategory(widget.bookIdCategory);
      List<dynamic> bookListData = data;

      _bookListByCategory = bookListData.map((listData) => Book.fromJson(listData)).toList();

      setState(() {
        _isLoading = false;
      });
    } on ApiException catch(ae){
      ae.printDetails();
      //esto en una snakbar
      print(ae.message);

    }catch(e){
      print('asfklsadjflkasjdfñlaksflaskdj');
    }

  }
  @override
  void initState() {
    readResponseBookList();

    super.initState();
  }

  //Importamos la categoria seleccionada
  String category = 'Infantil';
  List<BookPrueba> books = [
    BookPrueba(
        1,
        [
          "assets/images/portada.jpeg",
          "assets/images/portada1.jpg",
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
          "assets/images/portada1.jpg",
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
          "assets/images/portada1.jpg",
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
          "assets/images/portada1.jpg",
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
          "assets/images/portada1.jpg",
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
          "assets/images/portada1.jpg",
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
          "assets/images/portada1.jpg",
          "assets/images/portada2.jpeg"
        ],
        "El ingles se eneseña mal",
        "Martin",
        "Misterio",
        "a",
        10,
        5.0),
  ];

  String _selectedOption = 'Més recents';
  List<String> options = [
    'Més recents',
    'Preu ascendent',
    'Preu descendent',
    'Valoració ascendent',
    'Valoració descentent'
  ];

  @override
  Widget build(BuildContext context) {
    List<BookPrueba> sortedBooks;
    if (_selectedOption == 'Preu ascendent') {
      sortedBooks = books..sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedOption == 'Preu descendent') {
      sortedBooks = books..sort((a, b) => b.price.compareTo(a.price));
    } else if (_selectedOption == 'Valoració ascendent') {
      sortedBooks = books..sort((a, b) => a.rating.compareTo(b.rating));
    } else if (_selectedOption == 'Valoració descendent') {
      sortedBooks = books..sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      sortedBooks = books;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aqui va la categoria',
          style: TextStyle(color: AppColors.colorByCategoryTitle(category)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.colorByCategoryBG(category),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 240,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondaryCake,
                  borderRadius: BorderRadius.circular(20),
                  //border: Border.all(color: AppColors.secondary)
                ),
                child: DropdownButtonFormField(
                  //iconSize: 0.0,
                  icon: Container(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.sort, color: AppColors.secondary,),
                    border: InputBorder.none,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: AppColors.secondaryCake,
                  items: options.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Container(
                        width: 180,
                        child: Text(
                          option,
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                  value: _selectedOption,
                )),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sortedBooks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                print(sortedBooks[index].title);
                Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
                    arguments: sortedBooks[index]);
              },
                child:ListTile(
                leading: Image.asset(sortedBooks[index].img[1]),
                title: Text(sortedBooks[index].title),
                subtitle: Text('Precio: €${sortedBooks[index].price}'),
                trailing: CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 3.0,
                  percent: sortedBooks[index].rating / 5,
                  center: Text(
                    "${sortedBooks[index].rating}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: AppColors.colorByCategoryTitle(category)),
                  ),
                  progressColor: AppColors.colorByCategoryTitle(category),
                ),)
              );
            },
          ),
        ],
      ),
    );
  }
}
