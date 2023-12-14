import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CalendarioAcademico extends StatefulWidget {
  @override
  _CalendarioAcademicoState createState() => _CalendarioAcademicoState();
}

class _CalendarioAcademicoState extends State<CalendarioAcademico> {
  String? localPath;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    final ByteData bytes = await rootBundle
        .load('assets/Calendario-Academico-GRADO-Sept.Dic2023.pdf');
    final Directory tempDir = await getTemporaryDirectory();
    final File pdfFile =
        File('${tempDir.path}/Calendario-Academico-GRADO-Sept.Dic2023.pdf');

    await pdfFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    setState(() {
      localPath = pdfFile.path;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Calendario Academico',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoaded && localPath != null
          ? PDFView(
              filePath: localPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              pageSnap: false,
              defaultPage: 0,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
