import 'package:book_river/src/api/api_exception.dart';
import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/model/book.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';

class ListBookCategory extends StatefulWidget {
  ListBookCategory({
    Key? key,
    required this.bookIdCategory,
    required this.categoryName,
  }) : super(key: key);

  int bookIdCategory;
  String categoryName;

  @override
  State<ListBookCategory> createState() => _ListBookCategoryState();
}

class _ListBookCategoryState extends State<ListBookCategory> {
  bool _isLoading = true;

  List<Book> _bookListByCategory = [];

  Future<List<Book>> readResponseBookList(int category) async {
    try {
      _bookListByCategory = await RequestProvider()
          .getBookListByCategory(widget.bookIdCategory, category);
      setState(() {
        _isLoading = false;
      });

      return _bookListByCategory;
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    readResponseBookList(1);
    super.initState();
  }

  //Importamos la categoria seleccionada
  String category = 'Infantil';

  String _selectedOption = 'Més recents';
  List<String> options = [
    'Més recents',
    'Preu ascendent',
    'Preu descendent',
    'Valoració ascendent',
    'Valoració descendent'
  ];

  Future<void> updateBookListByCategory(String selectedOption) async {
    switch (selectedOption) {
      case 'Més recents':
        _bookListByCategory = await readResponseBookList(1);
        break;
      case 'Preu ascendent':
        _bookListByCategory = await readResponseBookList(3);
        break;
      case 'Preu descendent':
        _bookListByCategory = await readResponseBookList(4);
        break;
      case 'Valoració ascendent':
        _bookListByCategory = await readResponseBookList(1);
        break;
      case 'Valoració descendent':
        _bookListByCategory = await readResponseBookList(2);
        break;
      default:
        _bookListByCategory = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return _content();
  }

  Scaffold _content() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          //_bookListByCategory[0].categories[0].nameEs.toString(),
          style: TextStyle(color: AppColors.colorByCategoryTitle(category)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.colorByCategoryBG(category),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _categoryButton(),
          _bookList(),
        ],
      ),
    );
  }

  Widget _bookList() {
    if (_bookListByCategory.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left:12.0, right: 12, top: 12),
        child: Center(
            child: Text(
          'No tenemos ningun libro con esta categoria',
          style: TextStyle(
            color: AppColors.colorByCategoryTitle(category),
            fontSize: 20,
          ),
        )),
      );
    }

    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _bookListByCategory.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
                      arguments: _bookListByCategory[index]);
                },
                child: _bookItem(index));
          },
        ),
      ),
    );
  }

  ListTile _bookItem(int index) {
    return ListTile(
      leading: Image.network(
        _bookListByCategory[index].caratula![0].img!,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset('assets/images/portada.jpeg');
        },
      ),
      title: Text(_bookListByCategory[index].title!),
      subtitle: Text('Precio: €${_bookListByCategory[index].price}'),
      trailing: CircularPercentIndicator(
        radius: 20.0,
        lineWidth: 3.0,
        percent: _bookListByCategory[index].avgRating! / 5,
        center: Text(
          "${_bookListByCategory[index].avgRating}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
              color: AppColors.colorByCategoryTitle(category)),
        ),
        progressColor: AppColors.colorByCategoryTitle(category),
      ),
    );
  }

  Padding _categoryButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          width: 240,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: AppColors.secondaryCake,
            borderRadius: BorderRadius.circular(20),
            //border: Border.all(color: AppColors.secondary)
          ),
          child: DropdownButtonFormField(
            //iconSize: 0.0,
            icon: Container(),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.sort,
                color: AppColors.secondary,
              ),
              border: InputBorder.none,
            ),
            borderRadius: BorderRadius.circular(20),
            dropdownColor: AppColors.secondaryCake,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: SizedBox(
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
                updateBookListByCategory(_selectedOption);
                // _selectedOption = value!;
              });
            },
            value: _selectedOption,
          )),
    );
  }

  void _onRefresh() async {
    print('refreshing');
    //await updateBookListByCategory(_selectedOption);
    _refreshController.refreshCompleted();
  }
}
