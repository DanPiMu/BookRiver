import 'dart:io';
import 'package:book_river/src/api/request_helper.dart';
import 'package:book_river/src/config/app_colors.dart';
import 'package:book_river/src/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../api/api_exception.dart';

class AddNewShelve extends StatefulWidget {
  const AddNewShelve({Key? key}) : super(key: key);

  @override
  State<AddNewShelve> createState() => _AddNewShelveState();
}

class _AddNewShelveState extends State<AddNewShelve> {
  final _formKey = GlobalKey<FormState>();

  bool isPublicBool = false;

  //0 si es privada y 1 si es publica
  int isPublic = 0;

  publicCheck() {
    if (isPublicBool == true) {
      print('Es publica');
      isPublic = 1;
    } else {
      print('No es publica');
      isPublic = 0;
    }
  }

  File? image;

  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<bool> _addShelves() async {
    try {
      bool aux = await RequestProvider.addNewShelves({
        "name": _nameController.text,
        "description": _descriptionController.text,
        "privacity": isPublic
      }, image!);
      return aux;
    } on ApiException catch (ae) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta saltando la apiExeption${ae.message!}'),
      ));
      ae.printDetails();
    }
    return false;
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
          "assets/images/fondo_2.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        _content(context)
      ],
    );
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          title: Text(
            AppLocalizations.of(context)!.getString('add_shelf'),
            style: const TextStyle(fontSize: 18),
          ),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imgShelves(),
            _nameAndDescription(),
            _statusShelves(),
            Text(
              AppLocalizations.of(context)!.getString('shelf_warning'),
              style: TextStyle(fontSize: 10, color: AppColors.secondary),
            ),
            Text(
              "**Todos los campos son obligatorios",
              style: TextStyle(fontSize: 10, color: AppColors.secondary),
            ),
            const SizedBox(
              height: 30,
            ),
            _addButton(context)
          ],
        ),
      ),
    );
  }

  ElevatedButton _addButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            bool aux = await _addShelves();
            if (aux) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('priblemos'),
              ));
              print("No se añade");
            }
          }
        },
        child: Text(AppLocalizations.of(context)!.getString('add')));
  }

  Padding _statusShelves() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.getString('shelf_status')),
          Switch(
            activeColor: AppColors.tertiary,
            value: isPublicBool,
            onChanged: (value) {
              //publicCheck();
              setState(() {
                isPublicBool = value;
                publicCheck();
                print(isPublicBool);
                print(isPublic);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _nameAndDescription() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 15.0, bottom: 8, left: 8, right: 8),
            child: TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!
                      .getString('hint_shelf_name'),
                  labelText:
                      AppLocalizations.of(context)!.getString('shelf_name'),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 8, left: 8, right: 8),
              child: TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    //contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: const OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!
                        .getString('hint_shelf_description'),
                    labelText: AppLocalizations.of(context)!
                        .getString('shelf_description'),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _imgShelves() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          _showMyDialog();
        },
        child: image != null
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  image!,
                  width: double.infinity,
                  height: 270,
                ))
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 235, 251, 255)),
                width: double.infinity,
                height: 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      color: AppColors.tertiary,
                      size: 40,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .getString('add_image_shelf'),
                      style: TextStyle(color: AppColors.tertiary),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.getString('select_image')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.getString('choose_image')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.getString('gallery')),
              onPressed: () {
                pickImage();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.getString('camera')),
              onPressed: () {
                pickImageC();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
