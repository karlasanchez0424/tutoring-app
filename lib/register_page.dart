import 'package:flutter/material.dart';
import 'credentialsrequest.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.4,
              color: Colors.grey[300],
              child: Center(
                child: Image.asset('assets/imagendos.png'),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Text(
                'Bienvenido',
                style: TextStyle(
                    fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
              child: Text(
                'Inicia sesion usando las credenciales proporcionadas por el departamento de TI.',
                style: TextStyle(fontSize: screenWidth * 0.045, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 3, 40),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: screenWidth * 0.32),
              ),
              onPressed: () {},
              child: Text(
                'Iniciar Sesion',
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: screenWidth * 0.24),
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CredentialsRequestPage()),
                );
              },
              child: Text(
                'Solicitud de credenciales',
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.w300),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
