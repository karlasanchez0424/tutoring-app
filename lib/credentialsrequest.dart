import 'package:flutter/material.dart';
import 'logic/credentialslogic.dart';

class CredentialsRequestPage extends StatefulWidget {
  @override
  _CredentialsRequestPageState createState() => _CredentialsRequestPageState();
}

class _CredentialsRequestPageState extends State<CredentialsRequestPage> {
  final TextEditingController _emailController = TextEditingController();
  final CredentialsLogic _credentialsLogic = CredentialsLogic();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _requestCredentials() async {
    String email = _emailController.text;
    try {
      String response = await _credentialsLogic.requestCredentials(email);
      if (mounted) {
        _showResponseDialog(response);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Respuesta del Servidor"),
          content: Text(response),
          actions: <Widget>[
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double horizontalPadding = screenWidth > 600 ? screenWidth * 0.1 : 35.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Credenciales",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Image.asset('assets/logouni.png'),
              ),
              SizedBox(height: 60),
              Text(
                "Solicitud de credenciales",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Aula Virtual - Grado",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 35),
              Text(
                "Correo electrónico",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "johndoe@ucsd.edu.do",
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Coloque su correo electrónico para recibir sus credenciales. Si tiene alguna pregunta o necesita asistencia, no dude en ponerse en contacto con nuestro equipo de soporte: info@ucsd.edu.do',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0D173B),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: _requestCredentials,
                  child: Text(
                    'Enviar solicitud',
                    style: TextStyle(fontSize: 18),
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
