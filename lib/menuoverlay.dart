import 'package:flutter/material.dart';
import 'updates.dart';

class MenuOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(context, Icons.home, 'Inicio', '/home'),
            _buildDrawerItem(
                context, Icons.update, 'Actualizaciones', '/updates'),
            _buildDrawerItem(context, Icons.help, 'Centro de ayuda', '/help'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () => Navigator.of(context).pushNamed(route),
    );
  }
}
