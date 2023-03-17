import 'package:book_river/src/model/shelves.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../model/pruebas+/book_prueba.dart';

class DetailShelves extends StatefulWidget {
  DetailShelves({Key? key, required int this.shelvesId}) : super(key: key);

  int shelvesId;

  @override
  State<DetailShelves> createState() => _DetailShelvesState();
}

class _DetailShelvesState extends State<DetailShelves> {
  late Shelves shelvesObject;
  late bool isPublic;
  bool _isLoading = true;

  Future<void> _shelvesById() async {
    try {
      final data = await RequestProvider().getShelvesById(widget.shelvesId);
      shelvesObject = Shelves.fromJson(data);
      setState(() {
        _isLoading = false;
        if (shelvesObject.privacity == 1) {
          isPublic = true;
        } else {
          isPublic = false;
        }
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

  @override
  void initState() {
    _shelvesById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return _content(context);
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(shelvesObject.name!),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  print('apretao');
                  Navigator.pushNamed(context, NavigatorRoutes.editShelves,
                          arguments: shelvesObject)
                      .then((value) {
                    setState(() {
                      _shelvesById();
                    });
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: AppColors.secondary,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Bool si es publica la estanteria
                _statusShelves(),
                Text(
                  'Descripcio',
                  style: TextStyle(color: AppColors.tertiary, fontSize: 20),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(child: Text(shelvesObject.description!))),
                Text(
                  'Llibres',
                  style: TextStyle(color: AppColors.tertiary, fontSize: 20),
                ),
                _bookList(),
              ],
            ),
          ),
        ));
  }

  Padding _statusShelves() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Prestatgeria pública'),
          Switch(
            activeColor: AppColors.tertiary,
            value: isPublic,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  ListView _bookList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: shelvesObject.books.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: Container(
              width: 40,
              child: Image.network(
                shelvesObject.books[index].caratula![0].img!,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/portada.jpeg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            title: Text(shelvesObject.books[index].title!),
            subtitle: Text('Precio: €${shelvesObject.books[index].price}'),
            trailing: CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 3.0,
              percent: shelvesObject.books[index].avgRating! / 5,
              center: Text("${shelvesObject.books[index].avgRating}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: AppColors.secondary)),
              progressColor: AppColors.secondary,
            ));
      },
    );
  }
}
