import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:damm_app/ayuda.dart';
import 'package:damm_app/contacto.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String fechaProximaEntrega;

  @override
  void initState() {
    super.initState();
    fechaProximaEntrega = widget.fechaProximaEntrega;
  }

  Future<void> realizarPedido(BuildContext context, String barId) async {
    try {
      String apiUrl = 'http://nattech.fib.upc.edu:40540/api/bars/$barId/update';
      final response = await http.get(Uri.parse(apiUrl), headers: {});

      if (response.statusCode == 200) {
        String rawDate = response.body.replaceAll('"', ''); // Eliminar comillas
        DateTime nuevaFecha = DateFormat('yyyy-MM-dd').parse(rawDate);
        String formattedDate = DateFormat('dd/MM/yyyy').format(nuevaFecha);

        setState(() {
          fechaProximaEntrega = formattedDate;
        });

        print('Pedido realizado con éxito');
        showCustomDialog(context, 'Éxito', 'Pedido realizado con éxito.');
      } else {
        print('Error al realizar el pedido. Código de estado: ${response.statusCode}');
        showCustomDialog(context, 'Error', 'Error al realizar el pedido. Inténtelo de nuevo más tarde.');
      }
    } catch (e) {
      print('Error: $e');
      showCustomDialog(context, 'Error', 'Error al realizar el pedido. Inténtelo de nuevo más tarde.');
    }
  }

  void showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
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
                widget.nombreDelBar,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Ayuda y Soporte'),
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
                widget.nombreDelBar,
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
                '${widget.porcentajeCerveza} %',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () async {
                  await realizarPedido(context, widget.barId);
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
