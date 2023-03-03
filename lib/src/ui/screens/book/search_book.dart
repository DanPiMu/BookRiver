import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class SearchBook extends StatefulWidget {
  const SearchBook({Key? key}) : super(key: key);

  @override
  State<SearchBook> createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> with TickerProviderStateMixin {
  late TabController _tabController;

  String category = 'Infantil';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Scaffold _content() {
    return Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Descobreix llibres i persones',
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
            background: _searchBar(),
          ),
        ),

        /*TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: Text("It's rainy here"),
            ),
          ],
        ),*/
      ],
    ),
  );
  }

  Container _searchBar() {
    return Container(
            padding: EdgeInsets.only(bottom: 55, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.colorByCategoryTitle(category),
                    ),
                    hintText: "Buscar...",
                    hintStyle: TextStyle(
                        color: AppColors.colorByCategoryTitle(category)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  TabBar _tabBar() {
    return TabBar(
          indicatorColor: AppColors.colorByCategoryTitle(category),
          labelColor: AppColors.colorByCategoryTitle(category),
          //selected text color
          unselectedLabelColor: Colors.black,
          //Unselected text color
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: 'Llibres',
            ),
            Tab(
              text: 'Usuaris',
            ),
          ],
        );
  }
}
