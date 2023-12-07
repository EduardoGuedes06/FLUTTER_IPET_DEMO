import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyHomeApp_page.dart';
import 'package:aplication/Service/UserRegister.dart';
import 'package:aplication/Pages/LoginApp_page.dart';

class Register_page extends StatefulWidget {
  @override
  _RegisterApp_page createState() => _RegisterApp_page();
}

class _RegisterApp_page extends State<Register_page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController docController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController senhaController_ = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  double backgroundOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    final userCache = context.watch<UserRegister>();

    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: 300,
          height: 620,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 213, 213, 1.0)
                .withOpacity(backgroundOpacity),
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Color.fromRGBO(255, 213, 213, 1.0).withOpacity(0.5),
              width: 2.0,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: nomeController,
                        decoration: InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: docController,
                        decoration: InputDecoration(labelText: 'Documento'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Documento é obrigatório';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'E-mail'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-mail é obrigatório';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Senha'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Senha é obrigatória';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: senhaController_,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Confirme a senha'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme a senha';
                          } else if (value != senhaController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _autovalidateMode = AutovalidateMode.always;
                      backgroundOpacity = 0.2;
                    });

                    if (_formKey.currentState!.validate()) {
                      final registrationSuccessful =
                          await userCache.RegisterUser(
                        nomeController.text,
                        docController.text,
                        emailController.text,
                        senhaController.text,
                        senhaController_.text,
                      );

                      if (registrationSuccessful) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginApp_page(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Erro no Cadastro'),
                            content:
                                Text('Não foi possível realizar o cadastro.'),
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
                    primary: Color.fromRGBO(255, 213, 213, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(260, 60),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 20,
                child: Row(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 20,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Não tem uma conta? ',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginApp_page(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
