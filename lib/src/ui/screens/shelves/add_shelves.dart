import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/navigator_routes.dart';

class AddNewShelve extends StatefulWidget {
  const AddNewShelve({Key? key}) : super(key: key);

  @override
  State<AddNewShelve> createState() => _AddNewShelveState();
}

class _AddNewShelveState extends State<AddNewShelve> {
  bool isPublic = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Afegeix una prestatgeria',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true),
      body:SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 235, 251, 255)),
              width: double.infinity,
              height: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: AppColors.tertiary,size: 40,),
                  Text(
                    'Afegeix una imatge per aquesta prestatgeria',
                    style: TextStyle(
                      color:AppColors.tertiary
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:15.0, bottom: 8, left: 8, right: 8),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                    hintText: 'Nom de la prestatgeria',
                    labelText: 'Nom',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.only(top:15.0, bottom: 8, left: 8, right: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      //contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(),
                      hintText: 'Escriu aqui la teva descripcio',
                      labelText: 'Descripció',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Prestatgeria pública'),
                Switch(
                  activeColor: AppColors.tertiary,
                  value: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value;
                      print(isPublic);
                    });
                  },
                ),
              ],
            ),
          ),
          Text('*Tots els usuarios que visitin el teu perfil veuràn aquesta prestatgeria',style: TextStyle(
            fontSize: 10, color: AppColors.secondary
          ),),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Afegir'))
        ],
    ),),
    );
  }
}
