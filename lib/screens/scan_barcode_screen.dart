import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<String> scanBarCode() async {
  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    '#FF6666',
    'Cancel',
    true,
    ScanMode.BARCODE,
  );
  return barcodeScanRes;
}
