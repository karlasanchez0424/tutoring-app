import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Centro de Ayuda',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('¿Cómo podemos ayudarte?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                'Aquí encontrarás respuestas a preguntas frecuentes y cómo contactar con nuestro soporte técnico.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendEmail,
              child: Text('Contactar Soporte Técnico'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail() async {
    final String email = 'soporte@ucsd.edu.do';
    final String subject = Uri.encodeComponent('Consulta de Soporte Técnico');
    final String body = Uri.encodeComponent('Hola, necesito ayuda con...');

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('No se pudo abrir el cliente de correo.');
    }
  }
}
