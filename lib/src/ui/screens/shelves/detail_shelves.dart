import 'package:book_river/src/config/app_localizations.dart';
import 'package:book_river/src/model/shelves.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_colors.dart';
import '../../../config/routes/navigator_routes.dart';

class DetailShelves extends StatefulWidget {
  DetailShelves({Key? key, required this.shelvesId}) : super(key: key);

  int shelvesId;

  @override
  State<DetailShelves> createState() => _DetailShelvesState();
}

class _DetailShelvesState extends State<DetailShelves> {
  late Shelves shelvesObject;
  late bool isPublic;
  bool _isLoading = true;

  int isPublicBool =0;

  publicCheck() {
    if (isPublic == true) {
      print('Es publica');
      isPublicBool = 1;
    } else {
      print('No es publica');
      isPublicBool = 0;
    }
  }
  Future<bool> _updatePrivacity() async {
    try {
      bool aux = await RequestProvider.updatePrivacity({
        "privacity": isPublic
      },widget.shelvesId);
      return aux;
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta saltando la apiExeption${ae.message!}'),
      ));
    }
    return false;
  }

  Future<void> _shelvesById() async {
    try {
      shelvesObject = await RequestProvider().getShelvesById(widget.shelvesId);

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statusShelves(),
              Text('*Para cambiar el estado de la estanteria, tienes que editarla', style: TextStyle(color: Colors.red,fontSize: 12),),
              Text(
                AppLocalizations.of(context)!.getString('description'),
                style: TextStyle(color: AppColors.tertiary, fontSize: 20),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(shelvesObject.description!)),
              Text(
                AppLocalizations.of(context)!.getString('books'),
                style: TextStyle(color: AppColors.tertiary, fontSize: 20),
              ),
              _bookList(),
            ],
          ),
        ));
  }

  Padding _statusShelves() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.getString('shelf_status')),
          /*Switch(
            activeColor: AppColors.tertiary,
            value: isPublic,
            onChanged: (value) {
              setState(() {
                isPublic = value;
                publicCheck();
                print(isPublicBool);
                //_updatePrivacity();
              });
            },
          ),*/

          Switch(
            activeColor: AppColors.tertiary,
            value: isPublic,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _bookList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: shelvesObject.books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, NavigatorRoutes.bookDetails,
                  arguments: shelvesObject.books[index]);
            },
            child: ListTile(
                leading: SizedBox(
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
                )),
          );
        },
      ),
    );
  }
}
