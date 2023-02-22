import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class EditShelves extends StatefulWidget {
  const EditShelves({Key? key}) : super(key: key);

  @override
  State<EditShelves> createState() => _EditShelvesState();
}

class _EditShelvesState extends State<EditShelves> {
  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    return
      Stack(
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
          Scaffold(
            backgroundColor: Colors.transparent,
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                title: Text('Edita aquesta prestatgeria'),
                centerTitle: true,
                actions: [
                  Icon(Icons.delete)
                ],
              ),
              body:
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[350]),
                        width: double.infinity,
                        height: 270,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate, color: Colors.white,size: 40,),
                            Text(
                              'Afegeix una imatge per aquesta prestatgeria',
                              style: TextStyle(
                                  color:Colors.white
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
                        child: const Text('Desa els canvis'))
                  ],
                ),)
          )
        ],
      )
      ;
  }
}
