import 'package:flutter/material.dart';
import 'package:damm_app/login.dart';
import 'package:damm_app/ayuda.dart';
import 'package:damm_app/contacto.dart';

class HomeScreen extends StatelessWidget {
  final String barId;
  final String fechaProximaEntrega;
  final String porcentajeCerveza;
  final String nombreDelBar;

  HomeScreen({
    required this.barId,
    required this.fechaProximaEntrega,
    required this.porcentajeCerveza,
    required this.nombreDelBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Damm App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                nombreDelBar,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Ayuda'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
              },
            ),
            ListTile(
              title: Text('Contáctanos'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen()));
              },
            ),
            ListTile(
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                nombreDelBar,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 200),
              Text(
                'Fecha de la próxima entrega:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$fechaProximaEntrega',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Porcentaje de cerveza restante:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$porcentajeCerveza %',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  // Implementa la lógica para realizar el pedido
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 60),
                ),
                child: Text(
                  'Pedir Ya',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
