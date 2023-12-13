import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  String _formatDate(String rawDate) {
    final parsedDate = DateTime.parse(rawDate);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  Future<void> login(BuildContext context) async {
    final url = Uri.parse('http://nattech.fib.upc.edu:40540/user/accounts/login');

    final response = await http.post(
      url,
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final barId = responseData['barId'].toString();

      final barResponse = await http.get(Uri.parse('http://nattech.fib.upc.edu:40540/api/bars/$barId'));

      if (barResponse.statusCode == 200) {
        final Map<String, dynamic> barData = json.decode(barResponse.body);

        final fechaProximaEntregaRaw = barData['data'].toString(); // Ajusta según la respuesta real
        final fechaProximaEntrega = _formatDate(fechaProximaEntregaRaw); // Formatea la fecha

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(
              barId: barId,
              fechaProximaEntrega: fechaProximaEntrega,
              porcentajeCerveza: barData['percentatge'].toString(),
              nombreDelBar: barData['nom'],
            ),
          ),
              (route) => false,
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Inicio de sesión fallido. Correo electrónico y/o contraseña incorrectos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/damm_logo.png',
                  height: 200,
                  width: 300,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 50),

                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      login(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Por favor, completa todos los campos.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 60),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Petición de Cambio de Contraseña'),
                          content: const Text(
                              'Si ha olvidado su contraseña, pulse "Recuperar Contraseña" y le enviaremos un '
                                  'correo electrónico con instrucciones para restablecer su contraseña. En caso'
                                  ' contrario, pulse "Cancelar".'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Petición de Cambio de Contraseña Aceptada'),
                                      content: const Text(
                                          'Revise su correo electrónico y siga las instrucciones para restablecer su contraseña.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Recuperar Contraseña'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('¿Ha olvidado su contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
