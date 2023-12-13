import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';

class CurriculumPage extends StatefulWidget {
  @override
  _CurriculumScreenState createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumPage> {
  String curriculumPath = "";

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    fromAsset('assets/ingsistemascurriculum.pdf', 'ingsistemascurriculum.pdf')
        .then((f) {
      setState(() {
        curriculumPath = f.path;
      });
    });
  }

  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<void> downloadCurriculum() async {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
    if (await Permission.storage.isGranted) {
      var dir = await getExternalStorageDirectory();
      var file = File('${dir!.path}/curriculum.pdf');
      await file.writeAsBytes(File(curriculumPath).readAsBytesSync());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Curriculum descargado en ${dir.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de almacenamiento denegado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Curriculum de la carrera',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: curriculumPath.isEmpty
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: PDFView(
                      filePath: curriculumPath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageFling: false,
                      pageSnap: false,
                      fitPolicy: FitPolicy.BOTH,
                      preventLinkNavigation: false,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: downloadCurriculum,
                    child: Text(
                      'Descargar Curriculum',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 255, 255)!),
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.blue[800]!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
      ),
    );
  }
}
