import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _oldPassController = TextEditingController();
  var _newPassController = TextEditingController();
  var _confirmPassController = TextEditingController();

  Future<bool> _updatePass() async {
    try {
      bool aux = await RequestProvider.editUser({
        "actual_pass": _oldPassController.text,
        "password": _newPassController.text,
        "password_confirmation": _newPassController.text
      });
      return aux;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Scaffold _content(BuildContext context) {
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
            _oldPasswrd(),
            SizedBox(
              height: 20,
            ),
            _newPasswrd(),
            SizedBox(
              height: 20,
            ),
            _confirmPasswrd(),
            SizedBox(
              height: 20,
            ),
            _savePassword(context)
          ],
        ),
      ),
    ),
  );
  }

  Container _savePassword(BuildContext context) {
    return Container(
              padding: const EdgeInsets.only(left: 0, top: 40.0),
              child: ElevatedButton(
                child: const Text('Desa els canvis'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    bool aux = await _updatePass();

                    if (aux) {
                      Navigator.pop(context);
                    } else {
                      SnackBar(content: Text("No se actualiza"));
                      print("No se actualiza");
                    }
                  }
                },
              ));
  }

  TextFormField _confirmPasswrd() {
    return TextFormField(
      controller: _confirmPassController,
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
          );
  }

  TextFormField _newPasswrd() {
    return TextFormField(
      controller: _newPassController,
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
          );
  }

  TextFormField _oldPasswrd() {
    return TextFormField(
      controller: _oldPassController,
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
          );
  }
}
