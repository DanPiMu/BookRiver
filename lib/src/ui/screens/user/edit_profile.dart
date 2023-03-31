import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../api/api_exception.dart';
import '../../../api/request_helper.dart';
import '../../../config/app_localizations.dart';
import '../../../model/User.dart';

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

  bool _isLoading = true;
  late User myUser;

  Future<void> _myUser() async {
    try {
      myUser = await RequestProvider().getUser();

      setState(() {
        _isLoading = false;
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

  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _dateController = TextEditingController();

  @override
  void initState() {
    _myUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
                const SizedBox(
                  height: 20,
                ),
                _nameForm(),
                const SizedBox(
                  height: 20,
                ),
                _doB(context),
                const Align(
                  alignment: Alignment.centerLeft,
                    child: Text('*Campo obligatorio', style: TextStyle(color: Colors.red),)),
                _saveButton(context)
              ],
            ),
          ),
        ));
  }

  Container _saveButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 0, top: 40.0),
        child: ElevatedButton(
          child: Text(AppLocalizations.of(context)!.getString("save_changes")),
          onPressed: () async {
            if (_emailController.text == '') {
              _emailController.text = myUser.email!;
            }
            if (_nameController.text == '') {
              _nameController.text = myUser.username!;
            }
            if (_formKey.currentState!.validate()) {
              print(_emailController.text);
              print(_dateController.text);
              print(_nameController.text);
              bool aux = await _updateUser();

              if (aux) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: const OutlineInputBorder(),
          hintText: AppLocalizations.of(context)!.getString("hint_username"),
          labelText: '@${myUser.username}',
          //AppLocalizations.of(context)!.getString("username"),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          prefixText: '@',
          prefixStyle: const TextStyle(color: Colors.red)),
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
            //_formKey.currentState?.validate();
          });
        });
      },
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            border: const OutlineInputBorder(),
            labelText: AppLocalizations.of(context)!.getString("date_of_birth"),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold)),
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
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: const OutlineInputBorder(),
          hintText: AppLocalizations.of(context)!.getString("hint_email"),
          labelText: myUser.email,
          //AppLocalizations.of(context)!.getString("email"),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold)),
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
