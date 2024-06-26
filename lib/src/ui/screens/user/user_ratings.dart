import 'package:book_river/src/api/api_exception.dart';
import 'package:flutter/material.dart';

import '../../../api/request_helper.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_localizations.dart';
import '../../../model/User.dart';
import '../../../model/ratings.dart';

class UserRatings extends StatefulWidget {
  UserRatings({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  State<UserRatings> createState() => _UserRatingsState();
}

class _UserRatingsState extends State<UserRatings> {
  bool _isLoading = true;

  //Ratings
  List<Ratings> _booksRatingsList = [];

  Future<void> readResponseBooksRatings() async {
    try {
      _booksRatingsList =
          await RequestProvider().getUserRatings(widget.user.id!);
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
    readResponseBooksRatings();
    super.initState();
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
        title: Text(AppLocalizations.of(context)!.getString("ratings")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
            itemCount: _booksRatingsList.length,
            itemBuilder: (BuildContext context, int index) {
              return _ratingItem(index);
            }),
      ),
    );
  }

  Container _ratingItem(int index) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: ClipOval(
              child: Image.network(
                  "https://mbookriver.apiabalit2.com/storage/${_booksRatingsList[index].user!.userImg!}",
                  fit: BoxFit.cover, errorBuilder: (BuildContext context,
                      Object exception, StackTrace? stackTrace) {
                print(_booksRatingsList[index].user!.userImg!);
                return const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pepe.jpeg'),
                );
              }),
            ),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //nombre de el usuario
                Text('@${_booksRatingsList[index].user?.username}'),
                Row(
                  children: [
                    Text(_booksRatingsList[index].book!.title.toString(),
                        style: TextStyle(color: AppColors.tertiary)),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (indexStart) {
                        return Container(
                          child: Icon(
                            indexStart < _booksRatingsList[index].stars!
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.tertiary,
                            size: 17,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_booksRatingsList[index].review!)),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
