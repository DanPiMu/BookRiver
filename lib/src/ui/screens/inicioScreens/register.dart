import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
          child: Image.asset('assets/images/LoginText.png'),
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
            padding: const EdgeInsets.only(bottom:36,right: 130),
            child: Image.asset('assets/images/ImgR.png')),
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
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 200),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: true,
                              obscuringCharacter: "*",
                              //controller: _emailController,
                              decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                border: OutlineInputBorder(),
                                hintText:'samilton',
                                labelText: 'Username',
                                prefixText: '@',
                                prefixStyle:TextStyle(
                                  color: Colors.red
                                )
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter valid Email';
                                }
                                if (!RegExp(r'^\d{9}$').hasMatch(value!)) {
                                  return 'Enter a valid password with 9 characters';
                                }
                                return null;
                              },
                              //onSaved: ,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  //color: Colors.blue,
                                  width: 280,
                                  child: CheckboxListTile(
                                    contentPadding: const EdgeInsets.only(right: 0, left: 0),
                                    title: const Text('He llegit i accepto els termes i condicions i la política de privacitat',style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                    ),),
                                    checkColor: AppColors.white,
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Entrar')),
              ],
            )),
          ),
        )

      ],
    );
  }
}
