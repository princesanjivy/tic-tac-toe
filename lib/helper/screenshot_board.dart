import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

Future<XFile> screenshotBoard(GlobalKey globalKey) async {
  final RenderRepaintBoundary boundary =
  globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(pixelRatio: 3);
  final ByteData? byteData =
  await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  String tempName = DateTime
      .now()
      .microsecondsSinceEpoch
      .toString();

  final XFile fileData = XFile.fromData(
    pngBytes,
    mimeType: "image/png",
    name: tempName,
  );

  return fileData;
}
