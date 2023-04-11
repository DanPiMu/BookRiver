import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_localizations.dart';

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

  bool _oldPassVisibility = true;
  bool _newPassVisibility = true;
  bool _confirmPassVisibility = true;


  Future<bool> _updatePass() async {
    try {
      bool aux = await RequestProvider.editPassword({
        "actual_pass": _oldPassController.text,
        "password": _newPassController.text,
        "password_confirmation": _confirmPassController.text
      });
      return aux;
    } on ApiException catch (ae) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Esta saltando la apiExeption${ae.message!}'),
          ));
      ae.printDetails();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){ FocusScope.of(context).unfocus();},
        child: _content(context));
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.getString("edit_password")),
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
              const SizedBox(
                height: 20,
              ),
              _newPasswrd(),
              const SizedBox(
                height: 20,
              ),
              _confirmPasswrd(),
              const SizedBox(
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
          child:  Text(AppLocalizations.of(context)!.getString("save_changes")),
          onPressed: () async {
            if ( _newPassController.text == _confirmPassController.text &&_formKey.currentState!.validate()) {
              bool aux = await _updatePass();

              if (aux) {
                Navigator.pop(context);
              } else {
                const SnackBar(content: Text("No se actualiza"));
                print("No se actualiza");
              }
            }
          },
        ));
  }

  TextFormField _confirmPasswrd() {
    return TextFormField(
      controller: _confirmPassController,
      obscureText: _confirmPassVisibility,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: const OutlineInputBorder(),
        //en un futuro hacerlo funcional
        suffixIcon: IconButton(
          icon: _confirmPassVisibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: () {
            _confirmPassVisibility = !_confirmPassVisibility;

            setState(() {});
          },
        ),
        labelText: AppLocalizations.of(context)!.getString("hint_confirm_password"),
        //alignLabelWithHint: true
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter valid Password';
        }
        if (!RegExp(r'^.{7,}$').hasMatch(value!)) {
          return 'Enter a valid password with 8 characters';
        }
        return null;
      },
      //onSaved: ,
    );
  }

  TextFormField _newPasswrd() {
    return TextFormField(
      controller: _newPassController,
      obscureText: _newPassVisibility,
      obscuringCharacter: "*",
      decoration:  InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: const OutlineInputBorder(),
        //en un futuro hacerlo funcional
        suffixIcon: IconButton(
          icon: _newPassVisibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: () {
            _newPassVisibility = !_newPassVisibility;

            setState(() {});
          },
        ),        labelText: AppLocalizations.of(context)!.getString("hint_new_password"),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter valid Password';
        }
        if (!RegExp(r'^.{7,}$').hasMatch(value!)) {
          return 'Enter a valid password with 8 characters';
        }
        return null;
      },
      //onSaved: ,
    );
  }

  TextFormField _oldPasswrd() {
    return TextFormField(
      controller: _oldPassController,
      obscureText: _oldPassVisibility,
      obscuringCharacter: "*",
      decoration:  InputDecoration(
        contentPadding:
             const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: const OutlineInputBorder(),
        //en un futuro hacerlo funcional
        suffixIcon: IconButton(
          icon: _oldPassVisibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: () {
            _oldPassVisibility = !_oldPassVisibility;

            setState(() {});
          },
        ),
        labelText: AppLocalizations.of(context)!.getString("hint_old_password"),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter valid Password';
        }
        if (!RegExp(r'^.{7,}$').hasMatch(value!)) {
          return 'Enter a valid password with 8 characters';
        }
        return null;
      },
      //onSaved: ,
    );
  }
}
