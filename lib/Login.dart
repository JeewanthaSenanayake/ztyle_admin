import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  String _LogEmail = "";
  String _LogPassword = "";
  bool UsernamePassword = false;
  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 112, 114, 114),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(120, 0, 0, 0),
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(100),
            child: Center(
              child: Container(
                width: scrnwidth * 0.32,
                padding: EdgeInsets.all(35),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 219, 217, 217),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(120, 0, 0, 0),
                      offset: Offset(0, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Form(
                  key: _formkey1,
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/Icon/icon.png',
                          height: scrnheight * scrnwidth * 0.00015,
                        ),
                      ),
                      SizedBox(
                        height: scrnheight * 0.05,
                      ),
                      Container(
                        width: scrnwidth * 0.27,
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            icon: Icon(
                              Icons.account_circle_rounded,
                              size: 40.0,
                            ),
                            labelText: 'Email',
                          ),
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return 'Email can not be empty';
                            }

                            if (UsernamePassword) {
                              return 'Invalid Username or Password';
                            }

                            return null;
                          },
                          onSaved: (text) {
                            _LogEmail = text.toString();
                          },
                        ),
                      ),
                      Container(
                        width: scrnwidth * 0.27,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: true,
                          //controller: passwordController,
                          decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            icon: Icon(
                              Icons.explore_rounded,
                              size: 40.0,
                            ),
                            labelText: 'Password',
                          ),
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return 'Password cannot be empty';
                            }

                            if (UsernamePassword) {
                              return 'Invalid Username or Password';
                            }

                            return null;
                          },
                          onSaved: (text) {
                            _LogPassword = text.toString();
                          },
                        ),
                      ),
                      SizedBox(
                        height: scrnheight * 0.05,
                      ),
                      SizedBox(
                        width: scrnwidth * scrnheight * 0.0002,
                        height: scrnwidth * scrnheight * 0.00003,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formkey1.currentState!.validate()) {
                                _formkey1.currentState!.save();
                                print(_LogEmail);
                                print(_LogPassword);
                                if (_LogEmail == "ztyle123@gmail.com" &&
                                    _LogPassword == "ztyle@zaq123") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Navigation(DashSelector: 0)));
                                } else {
                                  setState(() {
                                    UsernamePassword = true;
                                  });
                                  _formkey1.currentState!.validate();
                                  setState(() {
                                    UsernamePassword = false;
                                  });
                                }
                              }
                            },
                            child: const Text("Login")),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
