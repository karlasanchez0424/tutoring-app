import 'package:flutter/material.dart';
import 'logic/updateslogic.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'calendarioacademico.dart';

class UpdatesPage extends StatefulWidget {
  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class UpdateInfo {
  final String title;
  final String subTitle;
  final String description;
  final String linkText;

  UpdateInfo({
    required this.title,
    required this.subTitle,
    required this.description,
    required this.linkText,
  });
}

class _UpdatesPageState extends State<UpdatesPage> {
  final UpdatesLogic updatesLogic = UpdatesLogic();
  List<dynamic> notifications = [];
  bool showAll = false;
  List<dynamic> comments = [];
  bool showAllNotifications = false;

  final List<UpdateInfo> updatesList = [
    UpdateInfo(
      title: '04-10',
      subTitle: 'Marzo',
      description:
          'Durante esta semana se estarán impartiendo los segundos exámenes parciales de cuatrimestre Enero- Abril del año en curso',
      linkText: 'Más información',
    ),
    UpdateInfo(
      title: '20-05',
      subTitle: 'Abril',
      description:
          'Durante esta semana se estarán impartiendo los exámenes diferidos correspondientes al cuatrimestre Enero- Abril del año en curso',
      linkText: 'Más información',
    ),
  ];

  void loadData() async {
    var notificationsData = await updatesLogic.fetchUpdates();
    var commentsData = await updatesLogic.fetchComments();

    if (notificationsData != null && commentsData != null) {
      setState(() {
        notifications = notificationsData;
        comments = commentsData;
      });
    }
  }

  String findComment(String? requestNumber) {
    if (requestNumber == null) {
      return 'No hay comentarios';
    }

    var commentData = comments.firstWhere(
      (comment) =>
          comment['request_number'] == requestNumber &&
          comment['comment'] != null,
      orElse: () => {"comment": "No hay comentarios"},
    );

    return commentData['comment'] ?? 'No hay comentarios';
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Actualizaciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _buildCarouselSection(),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mis notificaciones',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                  ),
                  if (notifications.length > 3 && !showAllNotifications)
                    TextButton(
                      onPressed: () =>
                          setState(() => showAllNotifications = true),
                      child: Text(
                        'Ver más',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                            fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: notifications
                    .take(showAllNotifications ? notifications.length : 3)
                    .map((notification) => _buildNotificationCard(notification))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSection() {
    return CarouselSlider.builder(
      itemCount: updatesList.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return _buildCarouselCard(updatesList[itemIndex]);
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 2.0,
        initialPage: 2,
      ),
    );
  }

  Widget _buildCarouselCard(UpdateInfo updateInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarioAcademico()),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(updateInfo.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500)),
              Text(updateInfo.subTitle,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Text(updateInfo.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(updateInfo.linkText,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.underline)),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    String comment = findComment(notification['request_n'] as String?);
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.grey[100],
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['title'],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              notification['message'],
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 8),
            Text(
              'Notas:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              comment,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
