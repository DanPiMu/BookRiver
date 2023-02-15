import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/navigator_routes.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  late String _password;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  _content() {
    return Stack(
      ///Aqui esta el fondo freestyle que hice
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 70),
            child: Image.asset('assets/images/FrametitleSingnIn.png')),
        Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 100, right: 20),
            child: Image.asset(
              'assets/images/FrameCirculosEstrella.png',
            )),
        Container(
            alignment: Alignment.topLeft,
            //padding: EdgeInsets.only(top:110, right: 20),
            child: Image.asset(
              'assets/images/FrameEstrellaGalaxia.png',
            )),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 190),
          child: Image.asset('assets/images/TextoIniciarSesion.png'),
        ),
        Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: Image.asset('assets/images/SeisEstrellitas.png')),
        Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(bottom: 100),
            child: Image.asset('assets/images/EstrellaGris.png')),
        Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(bottom: 0),
            child: Image.asset('assets/images/Agua.png')),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 250, right: 100),
            child: Image.asset('assets/images/SeisEstrellitas.png')),
        Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 36, right: 130),
            child: Image.asset('assets/images/ImgR.png')),

        ///Esta ya es la pantalla con los Widgets
        _screen()
      ],
    );
  }

  _screen() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.0),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ///Form y boton de Recuperar contraseña
            _form(),
            const SizedBox(
              height: 167,
            ),

            ///Boton de inciar
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, NavigatorRoutes.mainHolder);
                },
                child: const Text('Iniciar sessió')),

            ///Boton de Resgistrar
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, NavigatorRoutes.logIn);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.white)),
              child: const Text('Registrat aqui'),
            ),
          ],
        )),
      ),
    );
  }

  _form() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 280),
        child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  //controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your Email',
                    labelText: 'Email',
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
                  obscureText: true,
                  obscuringCharacter: "*",
                  //controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                    //en un futuro hacerlo funcional
                    suffixIcon: Icon(Icons.visibility),
                    hintText: 'Enter your Password',
                    labelText: 'Password',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'He oblidat la contraseña',
                      style: TextStyle(fontSize: 12),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, NavigatorRoutes.passwordRecovery);
                            },
                            child: Text(
                              'Recuperar',
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
