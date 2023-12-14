import 'package:flutter/material.dart';
import 'package:uni_app/welcome_page.dart';
import 'route_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'login_page.dart';
import 'user_model.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureStorage = new FlutterSecureStorage();

  String? accessToken = await secureStorage.read(key: 'access_token');
  Widget homePageWidget = MyHomePage();
  if (accessToken != null) {
    String? userDataJson = await secureStorage.read(key: 'user');
    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);
      User user = User.fromJson(userData);

      homePageWidget = HomePage(
        firstName: user.firstName,
        lastName: user.lastName,
      );
    } else {
      homePageWidget = LoginPage();
    }
  }

  runApp(MyApp(homePage: homePageWidget));
}

class MyApp extends StatelessWidget {
  final Widget homePage;

  MyApp({required this.homePage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UCSD APP',
      onGenerateRoute: RouteManager.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homePage,
    );
  }
}

class MyHomePage extends StatelessWidget {
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
                child: Image.asset('assets/imagenone.png'),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                'Haciendo camino al andar',
                style: TextStyle(
                    fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
              child: Text(
                'Bienvenido al portal académico de la Universidad Católica Santo Domingo, donde tendrás acceso a tus clases, calificaciones y solicitudes.',
                style: TextStyle(fontSize: screenWidth * 0.045, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 3, 40),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: screenWidth * 0.32),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
              child: Text(
                'Comenzar',
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
