import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<bool> _updateUser() async {
    try {
      bool aux = await RequestProvider.editUser({
        "username": _nameController.text,
        "birth_date": _dateController.text,
        "email": _emailController.text
      });
      return aux;
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Esta saltando la apiExeption${ae.message!}'),
      ));
    }
    return false;
  }

  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _content(context));
  }

  Scaffold _content(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.getString("edit_profile")),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _emailForm(),
                SizedBox(
                  height: 20,
                ),
                _nameForm(),
                SizedBox(
                  height: 20,
                ),
                _doB(context),
                _saveButton(context)
              ],
            ),
          ),
        ));
  }

  Container _saveButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 0, top: 40.0),
        child: ElevatedButton(
          child: Text(AppLocalizations.of(context)!.getString("save_changes")),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              print(_emailController.text);
              print(_dateController.text);
              print(_nameController.text);
              bool aux = await _updateUser();

              if (aux) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('no furrula'),
                ));
                print("No se actualiza");
              }
            }
          },
        ));
  }

  TextFormField _nameForm() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(),
          hintText: AppLocalizations.of(context)!.getString("hint_username"),
          labelText: AppLocalizations.of(context)!.getString("username"),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          prefixText: '@',
          prefixStyle: TextStyle(color: Colors.red)),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter some text';
        }

        return null;
      },
    );
  }

  InkWell _doB(BuildContext context) {
    return InkWell(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ).then((date) {
          setState(() {
            _selectedDate = date;
            _formKey.currentState?.validate();
          });
        });
      },
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            border: OutlineInputBorder(),
            labelText: AppLocalizations.of(context)!.getString("date_of_birth"),
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          return _selectedDate == null
              ? AppLocalizations.of(context)!.getString("select_date")
              : null;
        },
        controller: _dateController = TextEditingController(
            text: _selectedDate == null
                ? ''
                : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
      ),
    );
  }

  TextFormField _emailForm() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(),
          hintText: AppLocalizations.of(context)!.getString("hint_email"),
          labelText: AppLocalizations.of(context)!.getString("email"),
          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter valid Email';
        }
        if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
            .hasMatch(value!)) {
          return 'Enter a valid email address: xxxxx@xxxx.zzz';
        }
        return null;
      },
    );
  }
}
