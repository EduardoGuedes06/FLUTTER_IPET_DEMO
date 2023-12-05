import 'dart:ui';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Pages/RegisterApp_page.dart';
import 'package:aplication/Service/UserCache.dart';
import 'package:aplication/Service/RestService/LoginServiceRest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyHomeApp_page copy.dart';

class LoginApp_page extends StatefulWidget {
  @override
  _LoginApp_page createState() => _LoginApp_page();
}

class _LoginApp_page extends State<LoginApp_page> {
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
                  Container(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Image.asset('assets/wwwroot/patinha.png'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'IPET',
                        style: TextStyle(
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(255, 213, 213, 1.0),
                        ),
                      ),
                    ),
                  ),
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
                                  final loginSuccessful =
                                      await userCache.loginUser(
                                    emailController.text,
                                    passwordController.text,
                                  );

                                  if (loginSuccessful) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProdutosApp_page(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Erro no Login'),
                                        content:
                                            Text('Credenciais Incorretas.'),
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
                                'Login',
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
                                  'Não tem conta? ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => Register_page(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Cadastro',
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
