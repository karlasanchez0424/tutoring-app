import 'package:flutter/material.dart';
import 'package:uni_app/logic/studentinfo.dart';

class StudentInfoPage extends StatelessWidget {
  final StudentInfoLogic logic = StudentInfoLogic();

  StudentInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Información del Estudiante',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: logic.fetchStudentInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final studentInfo = snapshot.data!;
            final fullName =
                '${studentInfo['first_name']} ${studentInfo['last_name']}';
            final gpa = studentInfo['total_score'].toStringAsFixed(2);
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Text(
                  'Datos del estudiante',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 15,
                ),
                _buildInfoRow('Nombre completo:', fullName),
                _buildInfoRow('ID de estudiante:', studentInfo['student_id']),
                _buildInfoRow(
                    'Fecha de nacimiento:', studentInfo['date_of_birth']),
                _buildInfoRow('Género:', studentInfo['gender']),
                _buildInfoRow('Dirección:', studentInfo['address']),
                _buildInfoRow(
                    'Teléfono de contacto:', studentInfo['contact_phone']),
                _buildInfoRow('Email:', studentInfo['email']),
                _buildInfoRow('Carrera:', studentInfo['career']['name']),
                _buildInfoRow(
                    'Facultad:',
                    studentInfo['career']['pensum']['school']['faculty']
                        ['name']),
                _buildInfoRow('Promedio actual (GPA):', gpa),
              ],
            );
          } else {
            return Center(
                child: Text('No se encontró información del estudiante.'));
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
