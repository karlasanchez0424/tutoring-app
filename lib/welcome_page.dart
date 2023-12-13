import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'credentialsrequest.dart';

class WelcomePage extends StatelessWidget {
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
              width: 327,
              height: 345,
              color: Colors.white,
              child: Center(
                child: Image.asset('assets/imagendos.png'),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                'Bienvenido',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: Text(
                'Inicia sesion usando las credenciales proporcionadas por el departamento de TI.',
                style: TextStyle(fontSize: 18, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 3, 40),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 130),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                'Iniciar Sesion',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: screenWidth * 0.10),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
