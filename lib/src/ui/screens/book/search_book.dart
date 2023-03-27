import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/config/app_localizations.dart';
import 'package:book_river/src/model/User.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/book.dart';

class SearchBook extends StatefulWidget {
  const SearchBook({Key? key}) : super(key: key);

  @override
  State<SearchBook> createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> with TickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController _searchController = TextEditingController();
  List<Book> _bookList = [];
  List<User> _userList = [];
  bool _cargandoLibros = false;
  bool _cargandoAutores = false;

  String category = 'Infantil';

  Future<List<Book>> readResponseSearchList(String text) async {
    setState(() {
      _cargandoLibros = true;
      _cargandoAutores = true;
    });
    try {
      ///Cargando libros
      final data = await RequestProvider().getBooksByName(text);
      List<dynamic> bookListData = data;

      ///Cargando autores
      final data1 = await RequestProvider().getUsersByName(text);
      List<dynamic> userListData = data1;

      setState(() {
        ///Cargando libros
        _bookList =
            bookListData.map((listData) => Book.fromJson(listData)).toList();
        _cargandoLibros = false;

        ///Cargando autores
        _userList =
            userListData.map((listData) => User.fromJson(listData)).toList();
        _cargandoAutores = false;
      });

      return _bookList;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Scaffold _content() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(
                AppLocalizations.of(context)!.getString('books_and_persons'),
                style: TextStyle(
                    fontSize: 15,
                    color: AppColors.colorByCategoryTitle(category)),
              ),
              centerTitle: true,
              floating: true,
              pinned: true,
              backgroundColor: AppColors.colorByCategoryBG(category),
              expandedHeight: 180.0,
              bottom: _tabBar(),
              flexibleSpace: FlexibleSpaceBar(
                background: SearchBar(
                  textController: _searchController,
                  onTextChanged: (text) => readResponseSearchList(text),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Widget del Tab 1
            if (_cargandoLibros)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              SearchResultBookList(books: _bookList),
            // Widget del Tab 2
            if (_cargandoAutores)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              SearchResultUserList(users: _userList),
          ],
        ),
      ),
    );
  }

  TabBar _tabBar() {
    return TabBar(
      onTap: (value) => _searchController.clear(),
      indicatorColor: AppColors.colorByCategoryTitle(category),
      labelColor: AppColors.colorByCategoryTitle(category),
      //selected text color
      unselectedLabelColor: Colors.black,
      //Unselected text color
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          text: AppLocalizations.of(context)!.getString('books'),
        ),
        Tab(
          text: AppLocalizations.of(context)!.getString('users'),
        ),
      ],
    );
  }
}

class SearchResultBookList extends StatelessWidget {
  final List<Book> books;

  const SearchResultBookList({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
                arguments: book);
          },
          child: ListTile(
            leading: Image.network(book.caratula![0].img!, fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
              return Image.asset('assets/images/portada.jpeg');
            }),
            title: Text(book.title.toString()),
            subtitle: Text('Precio: €${book.price.toString()}'),
            trailing: CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 3.0,
                percent: book.avgRating! / 5,
                center: Text(
                  book.avgRating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors
                        .blue, //AppColors.colorByCategoryTitle(category)),
                  ),
                ),
                progressColor:
                    Colors.red //AppColors.colorByCategoryTitle(category),
                ),
          ),
        );
      },
    );
  }
}

class SearchResultUserList extends StatelessWidget {
  final List<User> users;

  const SearchResultUserList({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        final user = users[index];
        return GestureDetector(
          onTap: () => {
            Navigator.pushNamed(context, NavigatorRoutes.profileOtherUser,
                arguments: user)
          },
          child: ListTile(
            leading: Image.network(user.userImg!, fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
              return const CircleAvatar(
                backgroundImage: AssetImage('assets/images/pepe.jpeg'),
              );
            }),
            title: Text(user.username.toString()),
          ),
        );
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onTextChanged;

  const SearchBar({
    Key? key,
    required this.textController,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 55, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                //color: AppColors.colorByCategoryTitle(category),
              ),
              hintText: "Buscar...",
              //hintStyle: TextStyle(color: AppColors.colorByCategoryTitle(category)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            onChanged: onTextChanged,
          ),
        ],
      ),
    );
  }
}
