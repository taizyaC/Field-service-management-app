import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReportService {
  Future<void> generateAndShareReport(String clientName, String description, String location) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Service Report for $clientName'),
        ),
      ),
    );

    // Save PDF to temporary directory
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share the PDF
    Share.shareFiles([file.path], text: 'Here is your service report.');
  }
}

// ReportService reportService = ReportService();
// reportService.generateAndShareReport(clientName, serviceDescription, location);

