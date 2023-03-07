import 'package:book_river/src/api/api_exception.dart';
import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/config/routes/navigator_routes.dart';
import 'package:book_river/src/model/book.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';
import '../../../model/categories.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  //bools loadings
  bool novetatLoading = true;
  bool categoryLoading = true;

  //Novetats
  List<Book> _booksNovetatsList = [];

  Future<void> readResponseBooks() async {
    try{
      final data = await RequestProvider().getBooks();

      List<dynamic> bookListData = data['data']['books'];
      _booksNovetatsList =
          bookListData.map((bookData) => Book.fromJson(bookData)).toList();
      setState(() {
        novetatLoading = false;
      });
    } on ApiException catch(ae) {
      ae.printDetails();
      SnackBar(content: Text(ae.message!));
      rethrow;

    } catch(e) {
      print('Problemillas');
      rethrow;
    }

  }

  //Categories
  List<Categories> _categoriesList = [];

  Future<void> readResponseCategory() async {
    final data = await RequestProvider().getBooks();

    List<dynamic> categoryListData = data['data']['categories'];
    _categoriesList = categoryListData
        .map((categoryData) => Categories.fromJson(categoryData))
        .toList();
    setState(() {
      categoryLoading = false;
    });
  }

  @override
  void initState() {
    readResponseBooks();
    readResponseCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return novetatLoading && categoryLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _content();
  }

  Widget _content() {
    return Scaffold(
        appBar: _customAppBar(context, _categoriesList),
        body: Padding(
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
    return SizedBox(
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
      itemCount: _categoriesList.length,
      itemBuilder: (BuildContext context, int index, int a) {
        return GestureDetector(
          onTap: () {
            print(_categoriesList[index].nameEs);
            Navigator.pushNamed(context, NavigatorRoutes.listBookCategory,
              arguments: _categoriesList[index]
            );
          },
          child: _carrouselItemCategory(index),
        );
      },
      options: CarouselOptions(
        height: 240,
        viewportFraction: 1.0,
        aspectRatio: 1.5,
        enlargeCenterPage: true,
      ),
    );
  }

  Card _carrouselItemCategory(int index) {
    return Card(
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
                  _categoriesList[index].nameEs.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              //Text(bookCategories[index]['description']),
              Expanded(
                child: ListView.builder(
                  itemCount: _categoriesList[index].books.length,
                  itemBuilder: (BuildContext context, int bookIndex) {
                    var bookRating =
                        _categoriesList[index].books[bookIndex].avgRating!;
                    return _carouselBookItem(index, bookIndex, bookRating);
                    //Text(bookCategories[index]['books'][bookIndex]),
                  },
                ),
              ),
            ],
          ),
        );
  }

  ListTile _carouselBookItem(int index, int bookIndex, num bookRating) {
    return ListTile(
                    leading: Image.network(
                        _categoriesList[index]
                            .books[bookIndex]
                            .bookImgs![0]
                            .img
                            .toString(),
                        fit: BoxFit.cover, errorBuilder:
                            (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                      return Image.asset('assets/images/portada.jpeg');
                    }),
                    title: Text(_categoriesList[index]
                        .books[bookIndex]
                        .title
                        .toString()),
                    subtitle: Text(
                        'Precio: €${_categoriesList[index].books[bookIndex].price.toString()}'),
                    trailing: CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 3.0,
                        percent: bookRating / 5,
                        center: Text(
                          bookRating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: Colors
                                .blue, //AppColors.colorByCategoryTitle(category)),
                          ),
                        ),
                        progressColor: Colors
                            .red //AppColors.colorByCategoryTitle(category),
                        ),
                  );
  }
}

_customAppBar(BuildContext context, List<Categories> booksNovetatsList) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      child: Row(
        children: [
          Image.asset(
            "assets/images/BookRiver_logo_horizontal.png",
            height: 30,
            width: 150,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
          onPressed: () {
            print(booksNovetatsList.length);
            for (var books in booksNovetatsList) {
              print('con id: ${books.id} y no nomnbre: ${books.nameEs}');
            }
            Navigator.pushNamed(context, NavigatorRoutes.searchBook);
          },
          icon: Icon(
            Icons.search,
            color: AppColors.secondary,
          ))
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
            _imageBook(book),

            ///Pie Foto
            _caption(book),
          ],
        ),
      ));
}

Padding _imageBook(Book book) {
  return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 120,
              height: 180,
              child: Image.network(book.caratula![0].img.toString(),
                  fit: BoxFit.cover, errorBuilder: (BuildContext context,
                      Object exception, StackTrace? stackTrace) {
                return Image.asset('assets/images/portada.jpeg');
              }),
            ),
          );
}

Column _caption(Book book) {
  return Column(
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
                  book.categories.isNotEmpty
                      ? Text(
                          book.categories[0].nameEs.toString(),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        )
                      : const Text(
                          'No tiene categoria',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                  Text('${book.price.toString()}€')
                ],
              )
            ],
          );
}
