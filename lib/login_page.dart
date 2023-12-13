import 'package:flutter/material.dart';
import 'logic/login.dart';
import 'homepage.dart';
import 'user_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic _loginLogic = LoginLogic();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Container(
              width: 327,
              height: 345 * 0.2,
              color: Colors.white,
              child: Center(
                child: Image.asset('assets/logouni.png'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Iniciar sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Aula Virtual - Grado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 20),
            Text('Usuario:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.email,
                      size: MediaQuery.of(context).size.width * 0.07),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ejemplo: 2019-1234',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (!value.contains('@')) {}
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Contraseña:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock,
                      size: MediaQuery.of(context).size.width * 0.07),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length != 8) {}
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () async {
                final responseData = await _loginLogic.login(
                    _emailController.text, _passwordController.text);
                if (responseData != null && responseData.containsKey('error')) {
                  _showErrorDialog(responseData['error']);
                } else if (responseData != null &&
                    responseData['user'] != null) {
                  final user = User.fromJson(responseData['user']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        firstName: user.firstName,
                        lastName: user.lastName,
                      ),
                    ),
                  );
                } else {
                  _showErrorDialog('Datos de usuario no disponibles.');
                }
              },
              child: Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
