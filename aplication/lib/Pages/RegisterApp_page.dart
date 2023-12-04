import 'dart:ui';
import 'package:aplication/Service/UserCache.dart';
import 'package:aplication/Service/RestService/LoginServiceRest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyHomeApp_page copy.dart';

class Register_page extends StatefulWidget {
  @override
  _RegisterApp_page createState() => _RegisterApp_page();
}

class _RegisterApp_page extends State<Register_page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final userCache = context.watch<UserCache>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wwwroot/fundo.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(249, 214, 176, 245).withOpacity(0.1),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(255, 213, 213, 1.0),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autovalidateMode,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'E-mail'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Senha';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            // Add additional SizedBox for increased spacing
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _autovalidateMode = AutovalidateMode.always;
                                });

                                if (_formKey.currentState!.validate()) {
                                  // Use the registration function instead of login
                                  final registrationSuccessful =
                                      await userCache.RegisterUser(
                                    emailController.text,
                                    passwordController.text,
                                  );

                                  if (registrationSuccessful) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => MyHomeApp_page(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Erro no Cadastro'),
                                        content: Text(
                                            'Não foi possível realizar o cadastro.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromRGBO(255, 213, 213, 1.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                minimumSize: const Size(300, 60),
                              ),
                              child: const Text(
                                'Cadastro',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Já tem conta? ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => MyHomeApp_page(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
