import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../api/api_exception.dart';
import '../../../config/app_localizations.dart';
import '../../../config/routes/navigator_routes.dart';
import '../../../utils/user_helper_plantilla.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  bool _passVisibility = true;
  TextEditingController _passwordController = TextEditingController();

  Future<bool> _savePreferences() async {
    try {
      bool aux = await UserHelper.login({
        "email": _emailController.text,
        "password": _passwordController.text,
      });
      print(aux);
      return aux;
    } on ApiException catch (ae) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.getString(ae.message ?? "rc_1"))),
      );
      ae.printDetails();
    } catch (e) {
      print('xsrdctfvygbhunjimk,');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _screen();
  }

  _screen() {
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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Image.asset(
              'assets/images/BookRiver_logo.png',
              height: 160,
              width: 160,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Image.asset(
              'assets/images/LoginText.png',
            ),
          ),

          ///Form y boton de Recuperar contraseña
          _form(),
          const SizedBox(
            height: 167,
          ),

          ///Boton de inciar
          _loginButton(),

          ///Boton de Resgistrar
          _registerButton(),
        ],
      )),
    );
  }

  Row _registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Image.asset('assets/images/Frame 1.png'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, NavigatorRoutes.register);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.white)),
          child: Text(AppLocalizations.of(context)!.getString('sign_in_here')),
        ),
      ],
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            bool aux = await _savePreferences();
            if (aux) {
              Navigator.pushNamed(context, NavigatorRoutes.mainHolder);
            } else {}
          }
        },
        child: Text(AppLocalizations.of(context)!.getString("login")));
  }

  _form() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    border: const OutlineInputBorder(),
                    hintText:
                        AppLocalizations.of(context)!.getString('hint_email'),
                    labelText: AppLocalizations.of(context)!.getString("email"),
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _passVisibility,
                  obscuringCharacter: "*",
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    border: const OutlineInputBorder(),
                    //en un futuro hacerlo funcional
                    suffixIcon: IconButton(
                      icon: _passVisibility
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        _passVisibility = !_passVisibility;

                        setState(() {});
                      },
                    ),
                    hintText: AppLocalizations.of(context)!
                        .getString("hint_password"),
                    labelText:
                        AppLocalizations.of(context)!.getString("password"),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter valid Password';
                    }

                    if (!RegExp(r'^\d{9,}$').hasMatch(value!)) {
                      return 'Enter a valid password with 9 characters';
                    }
                    return null;
                  },
                  //onSaved: ,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .getString("forgot_password"),
                      style: const TextStyle(fontSize: 12),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, NavigatorRoutes.passwordRecovery);
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .getString('recover_password'),
                              style: TextStyle(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
