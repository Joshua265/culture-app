import 'package:culture_app/widgets/fetch_event_and_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:culture_app/models/event.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:culture_app/screens/event_screen.dart';

Future<String> scanBarCode() async {
  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    '#FF6666',
    'Cancel',
    true,
    ScanMode.BARCODE,
  );
  return barcodeScanRes;
}
