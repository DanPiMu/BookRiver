import 'package:book_river/src/api/api_exception.dart';
import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/config/app_localizations.dart';
import 'package:book_river/src/config/routes/navigator_routes.dart';
import 'package:book_river/src/model/book.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';
import '../../../model/categories.dart';
import '../book/list_book_category.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  //Carousel controller
  CarouselController buttonCarouselController = CarouselController();

  //bools loadings
  bool novetatLoading = true;
  bool categoryLoading = true;

  //Novetats
  List<Book> _booksNovetatsList = [];

  Future<void> readResponseBooks() async {
    try {
      _booksNovetatsList = await RequestProvider().getBooksNovetats();

      setState(() {
        novetatLoading = false;
      });

    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta saltando la apiExeption${ae.message!}'),
      ));
      rethrow;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Parece que algo no esta yendo bien, intentalo mas tarde'),
      ));
      rethrow;
    }
  }

  //Categories
  List<Categories> _categoriesList = [];

  Future<void> readResponseCategory() async {
    _categoriesList = await RequestProvider().getBooksCategory();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.getString("news"),
                style:
                    const TextStyle(fontFamily: 'Abril Fatface', fontSize: 20),
              ),
              _novetatsList(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.getString("categories"),
                    style: const TextStyle(fontFamily: 'Abril Fatface', fontSize: 20),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => buttonCarouselController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear),
                        icon: const Icon(Icons.arrow_back_ios_sharp),
                      ),
                      Image.asset('assets/images/Vectorstar.png'),
                      IconButton(
                        onPressed: () => buttonCarouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear),
                        icon: const Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    ],
                  )
                ],
              ),
              _carouselCategories(),
            ],
          ),
        ),
      ),
    );
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
      carouselController: buttonCarouselController,
      itemCount: _categoriesList.length,
      itemBuilder: (BuildContext context, int index, int a) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListBookCategory(
                        bookIdCategory: _categoriesList[index].id!,
                        categoryName: _categoriesList[index].nameEs!,
                      )),
            );
          },
          child: _carrouselItemCategory(index, _categoriesList),
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

  Card _carrouselItemCategory(int index, List<Categories> categoriesList) {
    return Card(
      color: categoriesList.isEmpty
          ? AppColors.defaultCategoryColor
          : AppColors.colorByCategoryBG(categoriesList[index].nameEs!),
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
      leading: SizedBox(
        height: 100,
        width: 40,
        child: Image.network(
          _categoriesList[index].books[bookIndex].bookImgs![0].img.toString(),
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset(
              'assets/images/portada.jpeg',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      title: Text(_categoriesList[index].books[bookIndex].title.toString()),
      subtitle: Text(
          'Precio: €${_categoriesList[index].books[bookIndex].price.toString()}'),
      trailing: CircularPercentIndicator(
          radius: 20.0,
          lineWidth: 3.0,
          percent: bookRating / 5,
          center: Text(
            bookRating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
              color: Colors.blue, //AppColors.colorByCategoryTitle(category)),
            ),
          ),
          progressColor: Colors.red //AppColors.colorByCategoryTitle(category),
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
        Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
            arguments: book);
      },
      child: SizedBox(
        width: 170,
        child: Card(
          color: book.categories.isEmpty
              ? AppColors.defaultCategoryColor
              : AppColors.colorByCategoryBG(book.categories[0].nameEs!),
          child: Column(
            children: [
              ///imagen
              _imageBook(book),

              ///Pie Foto
              _caption(book, context),
            ],
          ),
        ),
      ));
}

Padding _imageBook(Book book) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
      width: 120,
      height: 180,
      child: Image.network(book.caratula![0].img!, fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset('assets/images/portada.jpeg');
      }),
    ),
  );
}

Widget _caption(Book book, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          book.title!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          book.author!,
          style: const TextStyle(fontSize: 10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            book.categories.isNotEmpty
                ? Text(
                    book.categories[0].nameEs.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 9),
                  )
                : const Text(
                    'No tiene categoria',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
            Text('${book.price.toString()}€')
          ],
        )
      ],
    ),
  );
}
