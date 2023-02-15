import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: Image.asset('assets/images/RecuperarContraseñaText.png'),
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

        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              //backgroundColor: Color(0x44000000),
              elevation: 0,
            ),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.0),
            body:
            SingleChildScrollView(child:Column(
              children: [
                ///Form
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 180),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black
                                )
                              ),
                              child: const Text('Ajúda’ns a recuperar la teva contrassenya', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,

                              ),),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Introdueix el teu correu i t’enviarem les instruccions per a poder recuperar-la.',
                            style: TextStyle(
                              fontSize: 15
                            ),),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              //controller: _emailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                border: OutlineInputBorder(),
                                hintText: 'Enter your Email',
                                labelText: 'Email',
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter valid Email';
                                }
                                if (!RegExp(
                                    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
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
                ),
                const SizedBox(
                  height: 150,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Enviar')),
              ],
            )),
          ),
        )

      ],
    );
  }
}
