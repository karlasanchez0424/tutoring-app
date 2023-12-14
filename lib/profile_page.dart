import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';
import 'login_page.dart';
import 'route_manager.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onStudentInfoTap;

  ProfilePage({this.onStudentInfoTap});

  void _navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  void _logout(BuildContext context) async {
    final _storage = FlutterSecureStorage();

    String? accessToken = await _storage.read(key: 'access_token');
    print("Access Token before logout: $accessToken");

    await _storage.deleteAll();

    accessToken = await _storage.read(key: 'access_token');
    print("Access Token after logout: $accessToken");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 18.0),
              child: Text(
                'Perfil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 18,
            ),
            ListTile(
              leading: Image.asset('assets/vectorperfil.png'),
              title: Text('Información de estudiante'),
              onTap: () {
                _navigateTo(context, RouteManager.studentInfo);
              },
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Image.asset('assets/vectorcampana.png'),
              title: Text('Notificaciones'),
              onTap: () => _navigateTo(context, '/notifications'),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Image.asset('assets/vectorconfig.png'),
              title: Text('Configuración'),
              onTap: () => _navigateTo(context, '/settings'),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Image.asset('assets/vectorwarning.png'),
              title: Text('Sobre el app'),
              onTap: () => _navigateTo(context, '/about'),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Image.asset('assets/vectorinfo.png'),
              title: Text('Ayuda'),
              onTap: () => _navigateTo(context, '/help'),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 100.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                      ),
                      child: Text(
                        'Cerrar sesión',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
