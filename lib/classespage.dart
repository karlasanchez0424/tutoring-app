import 'package:flutter/material.dart';
import 'logic/classeslogic.dart';
import 'curriculum.dart';
import 'route_manager.dart';
import 'tutor_request.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  late final ClassesLogic classesLogic;
  late final Future<List<dynamic>> classesFuture;
  late final Future<List<dynamic>> dueClassesFuture;
  late final Future<List<dynamic>> approvedClassesFuture;
  late final Future<List<dynamic>> requestedTutoringsFuture;
  late final Future<List<dynamic>> acceptedTutoringsFuture;
  late final Future<List<dynamic>> declinedTutoringsFuture;

  @override
  void initState() {
    super.initState();
    classesLogic = ClassesLogic();
    classesFuture = classesLogic.fetchCurrentClasses();
    dueClassesFuture = classesLogic.fetchDueClasses();
    approvedClassesFuture = classesLogic.fetchApprovedClasses();
    requestedTutoringsFuture = classesLogic.fetchRequestedTutorings();
    acceptedTutoringsFuture = classesLogic.fetchAcceptedTutorings();
    declinedTutoringsFuture = classesLogic.fetchDeclinedTutorings();
  }

  void _navigateToCurriculumPage() {
    Navigator.of(context).pushNamed(RouteManager.curriculum);
  }

  Widget _buildClassItem(dynamic cls) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 24, right: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 49, 87),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cls['subject']['name'],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 24),
                Text(
                  'Código: ${cls['subject']['code']} - Créditos: ${cls['subject']['credits']}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  'Profesor/a: ${cls['teacher'] != null ? '${cls['teacher']['first_name']} ${cls['teacher']['last_name']}' : 'No disponible'}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          Icon(Icons.book, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var classesData = snapshot.data!;
            var regularClasses =
                classesData.where((c) => !c['is_tutoring_now']).toList();
            var tutoringClasses =
                classesData.where((c) => c['is_tutoring_now']).toList();

            return ListView(
              children: [
                _buildSection('Clases', regularClasses),
                _buildSection('Tutorías Actuales', tutoringClasses),
                FutureBuilder<List<dynamic>>(
                  future: dueClassesFuture,
                  builder: (context, dueSnapshot) {
                    return dueSnapshot.hasData
                        ? _buildSection(
                            'Asignaturas Pendientes', dueSnapshot.data!)
                        : SizedBox();
                  },
                ),
                FutureBuilder<List<dynamic>>(
                  future: approvedClassesFuture,
                  builder: (context, approvedSnapshot) {
                    return approvedSnapshot.hasData
                        ? _buildApprovedClassesSection(approvedSnapshot.data!)
                        : SizedBox();
                  },
                ),
                _buildTutoringExpansionSection(),
                _buildAccessQuickSection(),
              ],
            );
          } else {
            return Center(child: Text('No hay clases actuales.'));
          }
        },
      ),
    );
  }

  Widget _buildAccessQuickSection() {
    return Padding(
      padding: EdgeInsets.only(top: 28, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12, bottom: 8),
            child: Text(
              "Acceso rápido",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text("Currículum de la carrera"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CurriculumPage()),
              );
            },
            trailing: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Image.asset('assets/Vectorlapiz.png'),
            ),
          ),
          ListTile(
            title: Text("Solicitud de tutoría"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TutorRequestPage()),
              );
            },
            trailing: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Image.asset('assets/Vectorlapiz.png'),
            ),
          ),
        ],
      ),
    );
  }

  bool _isTutoringExpanded = false;

  Widget _buildTutoringExpansionSection() {
    return ExpansionTile(
      initiallyExpanded: _isTutoringExpanded,
      title: Text("Tutorías",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      trailing: Icon(_isTutoringExpanded
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down),
      onExpansionChanged: (bool expanded) {
        setState(() => _isTutoringExpanded = expanded);
      },
      children: <Widget>[
        _buildTutoringSection("Tutorías Solicitadas", requestedTutoringsFuture),
        _buildTutoringSection("Tutorías Aprobadas", acceptedTutoringsFuture),
        _buildTutoringSection("Tutorías Negadas", declinedTutoringsFuture),
      ],
    );
  }

  Widget _buildTutoringSection(
      String title, Future<List<dynamic>> tutoringsFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        FutureBuilder<List<dynamic>>(
          future: tutoringsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            } else if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                children: snapshot.data!.map(_buildClassItem).toList(),
              );
            } else {
              return Container(
                margin: EdgeInsets.only(left: 28),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Text(
                  'No hay $title.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> classes) {
    bool showMore = classes.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (showMore)
                TextButton(
                  onPressed: () => _showAllClassesPopup(title, classes),
                  child: Text(
                    'Ver más',
                    style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
            ],
          ),
        ),
        if (classes.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child:
                Text("No tiene ninguna $title", style: TextStyle(fontSize: 16)),
          ),
        ...classes.take(3).map(_buildClassItem).toList(),
      ],
    );
  }

  void _showAllClassesPopup(String title, List<dynamic> classes) {
    bool showAll = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: showAll ? classes.length : 3,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildClassItemForModal(classes[index]);
                  },
                ),
              ),
              actions: <Widget>[
                if (!showAll && classes.length > 10)
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        child: Text(
                          'Mostrar todas',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() => showAll = true);
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      child:
                          Text('Cerrar', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildApprovedClassesSection(List<dynamic> approvedClasses) {
    int itemCount = approvedClasses.length > 3 ? 3 : approvedClasses.length;
    bool showMore = approvedClasses.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Asignaturas Aprobadas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (showMore)
                InkWell(
                  onTap: () => _showAllApprovedClassesPopup(approvedClasses),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Ver más',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ...approvedClasses.take(itemCount).map(_buildClassItem).toList(),
      ],
    );
  }

  Widget _buildClassItemForModal(dynamic cls) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cls['subject']['name'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  'Código: ${cls['subject']['code']} - Créditos: ${cls['subject']['credits']}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
          Icon(Icons.book, color: Colors.black),
        ],
      ),
    );
  }

  void _showAllApprovedClassesPopup(List<dynamic> approvedClasses) {
    bool showAll = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Asignaturas Aprobadas'),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: showAll ? approvedClasses.length : 10,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildClassItemForModal(approvedClasses[index]);
                  },
                ),
              ),
              actions: <Widget>[
                if (!showAll && approvedClasses.length > 10)
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        child: Text(
                          'Mostrar todas',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() => showAll = true);
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      child:
                          Text('Cerrar', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAllDueClassesPopup(List<dynamic> classes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Asignaturas Pendientes'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: classes.length,
              itemBuilder: (context, index) {
                var cls = classes[index];
                return ListTile(
                  title: Text(cls['subject']['name']),
                  subtitle: Text(
                      'Código: ${cls['subject']['code']} - Créditos: ${cls['subject']['credits']}'),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
