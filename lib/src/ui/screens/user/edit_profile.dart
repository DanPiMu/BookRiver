import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar perfil'),
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
                  controller: _emailController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      border: OutlineInputBorder(),
                      hintText: 'ejemplo@mail.com',
                      labelText: 'Email',
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
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(),
                        labelText: 'Data de naixement',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (value) {
                      return _selectedDate == null ? 'Seleccione una fecha' : null;
                    },
                    controller: TextEditingController(
                        text: _selectedDate == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      border: OutlineInputBorder(),
                      hintText: 'Tu nombre',
                      labelText: 'Nom',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      prefixText: '@',
                      prefixStyle: TextStyle(color: Colors.red)),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter some text';
                    }

                    return null;
                  },
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
        ));
  }
}
