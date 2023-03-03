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

Future<List<Book>> readResponseBookList (int category) async {
    
    try {
      final data = await RequestProvider().getBookListByCategory(widget.bookIdCategory,category);
      List<dynamic> bookListData = data;

      setState(() {
        _bookListByCategory = bookListData.map((listData) => Book.fromJson(listData)).toList();
        _isLoading = false;
      });

      return _bookListByCategory;
      
    } on ApiException catch(ae) {
      ae.printDetails();
      //esto en una snakbar
      print(ae.message);
      
      throw ae; // lanzar la excepción de nuevo para manejarla en otro lugar si es necesario
    } catch(e) {
      print('asfklsadjflkasjdfñlaksflaskdj');
      throw e; // lanzar la excepción de nuevo para manejarla en otro lugar si es necesario
    }
  
  }

  
  @override
  void initState() {
    readResponseBookList(0);

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
    'Valoració descentent'
  ];

  Future<void> updateBookListByCategory(String selectedOption) async {
  switch (selectedOption) {
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
  if(_isLoading){
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
      _bookListByCategory[0].categories[0].nameEs.toString(),
      style: TextStyle(color: AppColors.colorByCategoryTitle(category)),
    ),
    centerTitle: true,
    backgroundColor: AppColors.colorByCategoryBG(category),
    actions: [
      ///Debugger prooo
      IconButton(onPressed: (){
        
      }, icon: Icon(Icons.abc_rounded))
    ],
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

  ListView _bookList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _bookListByCategory.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
          print(_bookListByCategory[index].title);
          Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
              arguments: _bookListByCategory[index]);
        },
          child:_bookItem(index)
        );
      },
    );
  }

  ListTile _bookItem(int index) {
    return ListTile(
        leading: Image.network(_bookListByCategory[index].caratula![0].toString(),
                  fit: BoxFit.cover, errorBuilder: (BuildContext context,
                  Object exception, StackTrace? stackTrace) {
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
        ),);
  }

  Padding _categoryButton() {
    return Padding(
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
                updateBookListByCategory(_selectedOption);
               // _selectedOption = value!;
              });
            },
            value: _selectedOption,
          )),
    );
  }
  
  }

