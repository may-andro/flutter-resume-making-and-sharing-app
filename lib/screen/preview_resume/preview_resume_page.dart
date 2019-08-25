import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class PDFScreen extends StatelessWidget {
  final String pathPDF;

  PDFScreen({@required this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Preview"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: _shareFile,
            ),
          ],
        ),
        path: pathPDF);
  }

  _shareFile() async {
    final ByteData bytes = await rootBundle.load(pathPDF);
    await WcFlutterShare.share(
        sharePopupTitle: 'share',
        fileName: '${pathPDF.substring(pathPDF.lastIndexOf("/") + 1)}',
        mimeType: 'application/pdf',
        bytesOfFile: bytes.buffer.asUint8List());
  }
}
