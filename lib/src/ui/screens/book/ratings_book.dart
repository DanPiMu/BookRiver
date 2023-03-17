import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/model/ratings.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../api/request_helper.dart';
import '../../../config/routes/navigator_routes.dart';

class RatingsBook extends StatefulWidget {
  RatingsBook({Key? key, required int this.bookId}) : super(key: key);

  int bookId;

  @override
  State<RatingsBook> createState() => _RatingsBookState();
}

class _RatingsBookState extends State<RatingsBook> {
  bool _isLoading = true;

  //Ratings
  List<Ratings> _booksRatingsList = [];

  Future<void> readResponseBooks() async {
    final data = await RequestProvider().getRatingsBookList(widget.bookId);

    List<dynamic> bookListData = data;
    _booksRatingsList =
        bookListData.map((bookData) => Ratings.fromJson(bookData)).toList();
    setState(() {
      _isLoading = false;
      print(_booksRatingsList.length);
    });
  }

  @override
  void initState() {
    readResponseBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    //Porcentaje
    double rating = _booksRatingsList[0].stars!.toDouble();
    double percentage = rating / 5;
    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          child: Image.asset(
            "assets/images/fondo_3.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        _content(percentage, rating, context)
      ],
    );
  }

  Scaffold _content(double percentage, double rating, BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.transparent,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
                title: LayoutBuilder(builder: (context, constraints) {
                  return Text(
                    'Valoracions',
                    style: TextStyle(
                      color: constraints.maxHeight > 70
                          ? Color.fromARGB(0, 0, 0, 0)
                          : Colors.black,
                    ),
                  );
                }),
                centerTitle: true,
                background: _appBarCustom(percentage, rating)),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NavigatorRoutes.profileOtherUser,
                      arguments: _booksRatingsList[index].user);
                },
                child: _ratingUserItem(index),
              ),
              childCount: _booksRatingsList.length,
            ),
          ),
        ],
      ),
      floatingActionButton: _ratingButton(context),
    );
  }

  FloatingActionButton _ratingButton(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: AppColors.secondaryCake,
        onPressed: () {
          print('apretado');
          Navigator.pushNamed(context, NavigatorRoutes.ratingBook,
              arguments: _booksRatingsList[0].book!);
        },
        label: Text(
          'Valorar',
          style: TextStyle(color: AppColors.secondary),
        ),
        icon: Icon(
          Icons.star,
          color: AppColors.secondary,
        ),
        elevation: 1);
  }

  Container _ratingUserItem(int index) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            child: Image.network(
              _booksRatingsList[index].user!.userImg.toString(),
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/portada2.jpeg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //nombre de el usuario
                Text(
                  '@${_booksRatingsList[index].user!.username.toString()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (indexStart) {
                    return Icon(
                      indexStart < _booksRatingsList[index].stars!
                          ? Icons.star
                          : Icons.star_border,
                      color: AppColors.tertiary,
                    );
                  }),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_booksRatingsList[index].review.toString())),
              ],
            ),
          ))
        ],
      ),
    );
  }

  SizedBox _appBarCustom(double percentage, double rating) {
    return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Valoracions',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/EstrellitaNaranja.png'),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 8.0,
                      percent: percentage,
                      center: Text(
                        "$rating",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: AppColors.secondary),
                      ),
                      progressColor: AppColors.secondary,
                    ),
                  ),
                  Image.asset('assets/images/EstrellitaNaranja.png'),
                ],
              )
            ],
          ),
        ));
  }
}
