import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/config/app_localizations.dart';
import 'package:book_river/src/model/ratings.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../api/api_exception.dart';
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
    try {
      _booksRatingsList =
          await RequestProvider().getRatingsBookList(widget.bookId);

      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (ae) {
      print(ae);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta saltando la apiExeption${ae.message!}'),
      ));
    }
  }

  @override
  void initState() {
    readResponseBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Image.asset(
          "assets/images/fondo_3.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        _booksRatingsList.isEmpty
            ? Scaffold(
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
                                    ? const Color.fromARGB(0, 0, 0, 0)
                                    : Colors.black,
                              ),
                            );
                          }),
                          centerTitle: true,
                          background: _appBarCustom(0, 0)),
                    ),
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Text('Este libro aun no tiene valoraciones...'),
                      ),
                    )
                    //Text('Este libro no tiene valoraciones aun')
                  ],
                ),
                floatingActionButton: _ratingButton(context),
              )
            : _content(context)
      ],
    );
  }

  Scaffold _content(BuildContext context) {
    //Porcentaje
    double rating = _booksRatingsList[0].stars!.toDouble();
    double percentage = rating / 5;
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
                          ? const Color.fromARGB(0, 0, 0, 0)
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
          Navigator.pushNamed(context, NavigatorRoutes.ratingBook,
                  arguments: widget.bookId)
              .then((_) => {
                    setState(() => {readResponseBooks()})
                  });
        },
        label: Text(
          AppLocalizations.of(context)!.getString('rate'),
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
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.network(
              _booksRatingsList[index].user!.userImg.toString(),
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/userK.jpeg',
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  AppLocalizations.of(context)!.getString('ratings'),
                  style: const TextStyle(fontSize: 20),
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
