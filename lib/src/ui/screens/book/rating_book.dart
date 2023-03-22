import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../api/api_exception.dart';
import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/book.dart';

class RatingBook extends StatefulWidget {
  RatingBook({
    Key? key,
    required int this.bookID,
  }) : super(key: key);

  int bookID;



  @override
  State<RatingBook> createState() => _RatingBookState();
}

class _RatingBookState extends State<RatingBook> {
  late Book bookRating;
  Future<void> _bookById() async {
    try {
      final data = await RequestProvider().getBookById(widget.bookID);
      bookRating = Book.fromJson(data);
      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (ae) {
      ae.printDetails();
      SnackBar(content: Text(ae.message!));
      rethrow;
    } catch (e) {
      print('Problemillas');
      rethrow;
    }
  }

  bool _isLoading = true;

  int _rating = 0;
  final myController = TextEditingController();

  @override
  void initState() {
    _bookById();
    super.initState();
  }

  void _onStarTapped(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
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

        _content()
      ],
    );
  }

  Scaffold _content() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          title: Text(
            AppLocalizations.of(context)!.getString('rate_book'),
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(bookRating.title.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(bookRating.author.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 200,
                  height: 280,
                  child: Image.network(
                    bookRating.bookImgs![0].img!,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset('assets/images/portada.jpeg');
                    },
                  ),
                ),
              ),
              _ratingNumber(),
              _ratingStars(),
              _bookComment(),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await RequestProvider().postRatingBook(
                        bookRating.id!, _rating, myController.text);
                    Navigator.of(context).pop();

                    //Navigator.pushNamed(context, NavigatorRoutes.bookDetails,arguments: bookRating);
                  } on ApiException catch (ae) {
                    ae.printDetails();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Esta saltando la apiExeption${ae.message!}'),
                        ));
                    rethrow;
                  } catch (e) {
                    print('Problemillas');
                    rethrow;
                  }
                },
                child: Text(AppLocalizations.of(context)!.getString('publish')),
              )
            ],
          ),
        ));
  }

  Padding _bookComment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15.0, bottom: 8, left: 8, right: 8),
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            expands: true,
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              //contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(),
              hintText: AppLocalizations.of(context)!.getString('hint_review'),
              labelText: AppLocalizations.of(context)!.getString('review'),
            ),
          ),
        ),
      ),
    );
  }

  Row _ratingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          icon: Icon(
            Icons.star,
            color: index < _rating ? Colors.blue : Colors.lightBlueAccent[100],
          ),
          onPressed: () => _onStarTapped(index + 1),
        ),
      ),
    );
  }

  Row _ratingNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/EstrellitaNaranja.png'),
        Padding(
          padding: const EdgeInsets.only(left: 13.0, right: 13.00),
          child: CircularPercentIndicator(
            radius: 35.0,
            lineWidth: 6.0,
            percent: _rating / 5,
            center: Text(
              "$_rating",
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
    );
  }
}
