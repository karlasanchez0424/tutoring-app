import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uni_app/classespage.dart';
import 'package:uni_app/profile_page.dart';
import 'route_manager.dart';
import 'user_model.dart';
import 'student_info.dart';
import 'logic/homepagelogic.dart';
import 'logic/classeslogic.dart';
import 'menuoverlay.dart';
import 'calendario.dart';

class HomePage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const HomePage({required this.firstName, required this.lastName, Key? key})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final HomePageLogic logic;
  late final Future<Map<String, dynamic>?> studentInfoFuture;

  late final List<Widget> _pages;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late final ClassesLogic classesLogic;
  late final Future<List<dynamic>> currentClassesFuture;

  @override
  void initState() {
    super.initState();
    logic = HomePageLogic();
    studentInfoFuture = logic.fetchStudentInfo();
    classesLogic = ClassesLogic();
    currentClassesFuture = classesLogic.fetchCurrentClasses();
    _pages = [
      FutureBuilder<Map<String, dynamic>?>(
        future: studentInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final studentInfo = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Text(
                      'Bienvenido,',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.firstName} ${widget.lastName}',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Datos del estudiante',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/studentInfo');
                          },
                          child: Text('Ver más',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                    _buildInfoContainer(
                        'Matrícula: ${studentInfo['student_id']}', context),
                    SizedBox(height: 10),
                    _buildInfoContainer(
                        'Grado: ${studentInfo['career']['name']}', context),
                    SizedBox(height: 30),
                    _buildClassesSection(),
                  ],
                ),
              ),
            );
          } else {
            return Center(
                child: Text('No se encontró información del estudiante.'));
          }
        },
      ),
      ClassesPage(),
      ProfilePage(),
    ];
  }

  Widget _buildClassesSection() {
    return FutureBuilder<List<dynamic>>(
      future: currentClassesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<dynamic> classes = snapshot.data!.take(3).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clases',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {
                        _onItemTapped(1);
                      },
                      child: Text('Ver más',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              ),
              ...classes
                  .map((cls) => Container(
                        margin: EdgeInsets.only(bottom: 16, left: 0, right: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 28),
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Profesor/a: ${cls['teacher'] != null ? '${cls['teacher']['first_name']} ${cls['teacher']['last_name']}' : 'No disponible'}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.book, color: Colors.white),
                          ],
                        ),
                      ))
                  .toList(),
              SizedBox(height: 50),
            ],
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('No hay clases actuales.'),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void goToStudentInfo() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StudentInfoPage(),
    ));
  }

  Widget _buildInfoContainer(String text, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0),
      height: 56,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 49, 87),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text('UCSD APP'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Acción para abrir notificaciones
            },
          ),
        ],
      ),
      drawer: MenuOverlay(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Clases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 45, 43, 42),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
