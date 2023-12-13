// este archivo se encarga de manejar las rutas de la app
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'classespage.dart';
import 'calendario.dart';
import 'profile_page.dart';
import 'user_model.dart';
import 'student_info.dart';
import 'curriculum.dart';
import 'updates.dart';
import 'helpage.dart';

class RouteManager {
  static const String homePage = '/home';
  static const String classes = '/classes';
  static const String calendar = '/calendar';
  static const String profilePage = '/profile';
  static const String studentInfo = '/studentInfo';
  static const String curriculum = '/curriculum';
  static const String updates = '/updates';
  static const String helpSupport = '/help';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (context) => HomePage(
                  firstName: args?['firstName'] ?? 'Nombre',
                  lastName: args?['lastName'] ?? 'Apellido',
                ));
      case classes:
        return MaterialPageRoute(builder: (context) => ClassesPage());
      case profilePage:
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case studentInfo:
        return MaterialPageRoute(builder: (context) => StudentInfoPage());
      case curriculum:
        return MaterialPageRoute(builder: (context) => CurriculumPage());
      case updates:
        return MaterialPageRoute(builder: ((context) => UpdatesPage()));
      case helpSupport:
        return MaterialPageRoute(builder: (context) => HelpAndSupportPage());
      default:
        throw FormatException('Route not found! Check route_manager.dart');
    }
  }
}
