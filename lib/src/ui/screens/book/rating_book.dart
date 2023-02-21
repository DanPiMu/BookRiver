import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';

class RatingBook extends StatefulWidget {
  const RatingBook({Key? key}) : super(key: key);

  @override
  State<RatingBook> createState() => _RatingBookState();
}

class _RatingBookState extends State<RatingBook> {
  int _rating = 0;

  void _onStarTapped(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
              Text('Titulo del libro',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('Autor del libro'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 200,
                  height: 280,
                  child: Image.asset(
                    'assets/images/portada.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < _rating
                          ? Colors.blue
                          : Colors.lightBlueAccent[100],
                    ),
                    onPressed: () => _onStarTapped(index + 1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 8, left: 8, right: 8),
                    child: TextFormField(
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
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Valorar'),
              )
            ],
          ),
        ));

    /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            ElevatedButton(onPressed: () {}, child: Text('Valorar')));*/
  }
}
