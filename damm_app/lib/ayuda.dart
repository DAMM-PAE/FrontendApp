import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: HelpScreen(),
    );
  }
}

class HelpScreen extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();

  Future<void> sendEmail(String message, BuildContext context) async {
    final Email email = Email(
      body: message,
      subject: 'Ayuda desde la aplicación Damm App',
      recipients: ['beerdrivesupp@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      // Muestra un mensaje de éxito
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mensaje Enviado'),
            content: Text('Su mensaje ha sido enviado con éxito.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Muestra un mensaje de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Hubo un problema al enviar su mensaje. Inténtelo de nuevo más tarde.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
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
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text('Ayuda'),
      ),
    body: SingleChildScrollView(
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'Escriba sus preguntas o sugerencias:',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                Text(
                  'Escriba su mensaje y presione "Enviar" para que su comentario llegue a nuestro equipo de soporte.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Tu mensaje',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 150),
                ElevatedButton(
                  onPressed: () {
                    String message = messageController.text;
                    if (message.isNotEmpty) {
                      sendEmail(message, context);
                    } else {
                      // Muestra un mensaje de error si el mensaje está vacío
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Por favor, escribe tu mensaje antes de enviarlo.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
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
                    minimumSize: Size(200, 60),
                  ),
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
