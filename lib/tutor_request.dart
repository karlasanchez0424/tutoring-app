import 'package:flutter/material.dart';
import 'logic/tutorlogic.dart';
import 'package:intl/intl.dart';

class TutorRequestPage extends StatefulWidget {
  @override
  _TutorRequestPageState createState() => _TutorRequestPageState();
}

class _TutorRequestPageState extends State<TutorRequestPage> {
  late final TutorRequestLogic tutorRequestLogic;
  late final Future<Map<String, dynamic>> studentInfoFuture;
  late final Future<List<dynamic>> dueClassesFuture;
  late final Future<List<dynamic>> periodsFuture;
  String? selectedSubjectName;
  bool canSelect = true;
  String? selectedSubjectId;
  String? selectedPeriodId;
  String? selectedPeriodName;
  List<Map<String, dynamic>> periods = [];
  DateTime requestTime = DateTime.now();
  String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    tutorRequestLogic = TutorRequestLogic();
    studentInfoFuture = tutorRequestLogic.fetchStudentInfo();
    dueClassesFuture = tutorRequestLogic.fetchDueClasses();
    periodsFuture = tutorRequestLogic.fetchPeriods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: Text(
          'Solicitud de Tutoría',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 12),
          _buildCreditsInfo(),
          SizedBox(height: 12),
          _buildSubjectSelection(),
          SizedBox(height: 14),
          _buildPeriodSelection(),
          SizedBox(height: 24),
          _buildSummary(),
          SizedBox(height: 18),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildCreditsInfo() {
    return FutureBuilder<Map<String, dynamic>>(
      future: studentInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var data = snapshot.data!;
          print(data);
          int totalCreditsPending = data['total_credit_pending'] ?? 0;
          int totalCreditsOngoing = data['total_credit_ongoing'] ?? 0;
          int remainingCredits = totalCreditsPending - totalCreditsOngoing;
          canSelect = remainingCredits <= 10;

          return Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Actualmente usted posee ${data['total_credit_approved']} créditos aprobados. ',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return Text('No se pudo obtener la información del estudiante.');
        }
      },
    );
  }

  Widget _buildSubjectSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder<List<dynamic>>(
        future: dueClassesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var data = snapshot.data!
                .where((c) => c['subject']['is_tutoring'])
                .toList();

            return DropdownButtonFormField<String>(
              hint: Text('Seleccione una asignatura',
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  )),
              value: selectedSubjectId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSubjectId = newValue;
                  selectedSubjectName = data.firstWhere(
                      (element) =>
                          element['subject']['id'].toString() == newValue,
                      orElse: () => {
                            'subject': {'name': 'No seleccionada'}
                          })['subject']['name'];
                });
              },
              items: data.map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value['subject']['id'].toString(),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Text(
                      '${value['subject']['name']} (${value['subject']['code']}) - Créditos: ${value['subject']['credits']}',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          } else {
            return Text(
                'No hay asignaturas pendientes disponibles para tutoría.');
          }
        },
      ),
    );
  }

  Widget _buildPeriodSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder<List<dynamic>>(
        future: periodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var ongoingPeriod = snapshot.data!.firstWhere(
                (p) => p['status'] == 'ongoing',
                orElse: () => null);
            var nextPeriodId =
                ongoingPeriod != null ? ongoingPeriod['next_period'] : null;

            var nextPeriod = nextPeriodId != null
                ? snapshot.data!.firstWhere((p) => p['id'] == nextPeriodId,
                    orElse: () => null)
                : null;

            if (nextPeriod != null) {
              selectedPeriodId = nextPeriod['id'].toString();
              String periodText =
                  '${nextPeriod['name']} (${nextPeriod['start_date']} - ${nextPeriod['end_date']})';

              return DropdownButtonFormField<String>(
                hint: Text(
                  'Seleccione el período',
                  style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
                value: selectedPeriodId,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPeriodId = newValue;
                    selectedPeriodName = snapshot.data!.firstWhere(
                        (element) => element['id'].toString() == newValue,
                        orElse: () => {'name': 'No seleccionado'})['name'];
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: nextPeriod['id'].toString(),
                    child: Text(
                      periodText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                isDense: false,
                selectedItemBuilder: (BuildContext context) {
                  return snapshot.data!.map<Widget>((dynamic item) {
                    String itemText =
                        '${item['name']} (${item['start_date']} - ${item['end_date']})';
                    return Container(
                      width: MediaQuery.of(context).size.width - 60,
                      child: Text(
                        itemText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList();
                },
              );
            } else {
              return Text('No hay un próximo período disponible.');
            }
          } else {
            return Text('No se pudieron obtener los períodos.');
          }
        },
      ),
    );
  }

  Widget _buildSummary() {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(requestTime);

    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Resumen de la Solicitud',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // Información
            Text(
              'Asignatura: ${selectedSubjectName ?? "No seleccionada"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Período: ${selectedPeriodName ?? "No seleccionado"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Fecha y Hora de Solicitud: $formattedDateTime',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showMessagePopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 18),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (selectedSubjectId != null && selectedPeriodId != null) {
            String serverResponse = await tutorRequestLogic.sendTutorRequest(
                selectedSubjectId!, selectedPeriodId!);

            _showMessagePopup(serverResponse);
          } else {
            _showMessagePopup('Seleccione una asignatura y un período.');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Solicitar Tutoría',
            style: TextStyle(fontSize: 22),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[900]!),
          overlayColor: MaterialStateProperty.all<Color>(Colors.blue[800]!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
