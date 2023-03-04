import 'package:book_river/src/api/request_helper.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/book.dart';

class RatingBook extends StatefulWidget {
  RatingBook({
    Key? key,
    required Book this.bookRating,
  }) : super(key: key);

  Book bookRating;

  @override
  State<RatingBook> createState() => _RatingBookState();
}

class _RatingBookState extends State<RatingBook> {
  int _rating = 0;
  final myController = TextEditingController();

  void _onStarTapped(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            'Valora aquest llibre',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.bookRating.title.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(widget.bookRating.author.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 200,
                  height: 280,
                  child: Image.network(
                    widget.bookRating.caratula![0].img!,
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
                  await RequestProvider().postRatingBook(
                      widget.bookRating.id!, _rating, myController.text);
                  Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
                      arguments: widget.bookRating);
                },
                child: Text('Valorar'),
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
            decoration: const InputDecoration(
              //contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(),
              hintText: 'Escriu aqui la teva ressenya',
              labelText: 'Ressenya',
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
