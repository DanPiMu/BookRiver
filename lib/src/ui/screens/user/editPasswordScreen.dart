import 'package:flutter/material.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canviar contrasenya'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                  //en un futuro hacerlo funcional
                  suffixIcon: Icon(Icons.visibility),
                  labelText: 'Contrasenya anterior',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter valid Password';
                  }
                  if (!RegExp(r'^\d{9}$').hasMatch(value!)) {
                    return 'Enter a valid password with 9 characters';
                  }
                  return null;
                },
                //onSaved: ,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                  //en un futuro hacerlo funcional
                  suffixIcon: Icon(Icons.visibility),
                  labelText: 'Nueva contraseña',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter valid Password';
                  }
                  if (!RegExp(r'^\d{9}$').hasMatch(value!)) {
                    return 'Enter a valid password with 9 characters';
                  }
                  return null;
                },
                //onSaved: ,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                  //en un futuro hacerlo funcional
                  suffixIcon: Icon(Icons.visibility),
                  labelText: 'Confirmar constrasenya',
                  //alignLabelWithHint: true
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter valid Password';
                  }
                  if (!RegExp(r'^\d{9}$').hasMatch(value!)) {
                    return 'Enter a valid password with 9 characters';
                  }
                  return null;
                },
                //onSaved: ,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 0, top: 40.0),
                  child: ElevatedButton(
                    child: const Text('Desa els canvis'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print('Guardado');
                        Navigator.pop(context);
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
