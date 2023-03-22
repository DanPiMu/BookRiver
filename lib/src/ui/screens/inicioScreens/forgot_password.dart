import 'package:flutter/material.dart';

import '../../../api/api_exception.dart';
import '../../../config/app_localizations.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../utils/user_helper_plantilla.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  TextEditingController _emailController = TextEditingController();


  Future<bool> _recoveryPass() async {
    try {
      bool aux = await UserHelper.recovery({
        "email": _emailController.text,

      });
      return aux;
    } on ApiException catch (ae) {
      ae.printDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.getString(ae.message ?? "rc_1"))),
      );
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
          "assets/images/fondo.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: _content(),
        )
      ],
    );
  }

  Scaffold _content() {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        //backgroundColor: Color(0x44000000),
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: .0),
            child: Image.asset(
              'assets/images/BookRiver_logo.png',
              height: 130,
              width: 160,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Image.asset(
              'assets/images/ForgotPasswrdText.png',
            ),
          ),

          ///Form
          _form(),
          const SizedBox(
            height: 170,
          ),
          _sendButton(),
        ],
      )),

    );

  }

  ElevatedButton _sendButton() =>
      ElevatedButton(onPressed: () async {



        if (_formKey.currentState!.validate()) {
          bool aux = await _recoveryPass();
          if (aux) {
            final snackBar = SnackBar(
              content: Text('Te hemos enviado un correo, revisa tu bandeja de entrada'),
              action: SnackBarAction(
                label: 'Iniciar sesion',
                onPressed: () {
                  Navigator.pushNamed(context, NavigatorRoutes.login);
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //Navigator.pushNamed(context, NavigatorRoutes.login);
          } else {
            print("no entro");
          }
        }
      }, child:  Text(AppLocalizations.of(context)!.getString('send')));

  Container _form() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 SizedBox(
                  width: 250,
                  child: Text(
                    AppLocalizations.of(context)!.getString('recovery_text1'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                 Text(
                  AppLocalizations.of(context)!.getString('recovery_text2'),
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration:  InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.getString('hint_email'),
                    labelText: AppLocalizations.of(context)!.getString('email'),
                  ),
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
                  //onSaved: ,
                ),
              ],
            )),
      ),
    );
  }

}
