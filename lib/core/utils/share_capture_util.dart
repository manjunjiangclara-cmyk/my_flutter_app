import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum ShareOutcome { success, cancelled, failed }

class ShareCaptureUtil {
  const ShareCaptureUtil._();

  static Future<Uint8List?> captureBytes({
    required BuildContext context,
    required GlobalKey boundaryKey,
    double? pixelRatio,
    double? padding,
    Color? backgroundColor,
  }) async {
    final boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }

    final effectivePixelRatio =
        pixelRatio ?? UIConstants.shareCapturePixelRatio;
    final image = await boundary.toImage(pixelRatio: effectivePixelRatio);

    final double paddingLogical = padding ?? UIConstants.shareCapturePadding;
    final double marginPx = paddingLogical * effectivePixelRatio;
    final int outWidth = (image.width + marginPx * 2).toInt();
    final int outHeight = (image.height + marginPx * 2).toInt();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final Color bg =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    final paint = Paint()..color = bg;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, outWidth.toDouble(), outHeight.toDouble()),
      paint,
    );
    canvas.drawImage(image, Offset(marginPx, marginPx), Paint());

    final composed = await recorder.endRecording().toImage(outWidth, outHeight);
    final byteData = await composed.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    return byteData.buffer.asUint8List();
  }

  static Future<File?> captureToTempPng({
    required BuildContext context,
    required GlobalKey boundaryKey,
    double? pixelRatio,
    double? padding,
    Color? backgroundColor,
    String? fileNamePrefix,
  }) async {
    final bytes = await captureBytes(
      context: context,
      boundaryKey: boundaryKey,
      pixelRatio: pixelRatio,
      padding: padding,
      backgroundColor: backgroundColor,
    );
    if (bytes == null) return null;

    final dir = await getTemporaryDirectory();
    final filePath = p.join(
      dir.path,
      '${fileNamePrefix ?? 'hibi_journal'}_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<ShareOutcome> shareToApps({
    required BuildContext context,
    required GlobalKey boundaryKey,
    double? pixelRatio,
    double? padding,
    Color? backgroundColor,
    String subject = 'Journal',
    String? fileNamePrefix,
  }) async {
    final file = await captureToTempPng(
      context: context,
      boundaryKey: boundaryKey,
      pixelRatio: pixelRatio,
      padding: padding,
      backgroundColor: backgroundColor,
      fileNamePrefix: fileNamePrefix,
    );
    if (file == null) return ShareOutcome.failed;
    try {
      await Share.shareXFiles([XFile(file.path)], subject: subject);
      // No reliable completion signal; treat as neutral to avoid false success
      return ShareOutcome.cancelled;
    } catch (_) {
      return ShareOutcome.failed;
    }
  }

  static Future<bool> saveToPhotos({
    required BuildContext context,
    required GlobalKey boundaryKey,
    double? pixelRatio,
    double? padding,
    Color? backgroundColor,
    String? fileNamePrefix,
  }) async {
    final bytes = await captureBytes(
      context: context,
      boundaryKey: boundaryKey,
      pixelRatio: pixelRatio,
      padding: padding,
      backgroundColor: backgroundColor,
    );
    if (bytes == null) return false;
    final result = await ImageGallerySaver.saveImage(
      bytes,
      name:
          '${fileNamePrefix ?? 'hibi_journal'}_${DateTime.now().millisecondsSinceEpoch}',
    );
    return (result['isSuccess'] == true) || (result['filePath'] != null);
  }
}
