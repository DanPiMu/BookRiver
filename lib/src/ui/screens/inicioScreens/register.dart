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
          child: Scaffold(
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
                    'assets/images/RegisterText.png',
                  ),
                ),

                ///Form
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              //controller: _emailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  hintText: 'samilton',
                                  labelText: 'Username',
                                  prefixText: '@',
                                  prefixStyle: TextStyle(color: Colors.red)),
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
                                    contentPadding: const EdgeInsets.only(
                                        right: 0, left: 0),
                                    title: const Text(
                                      'He llegit i accepto els termes i condicions i la política de privacitat',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    checkColor: AppColors.white,
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
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
