import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile> compressImage({required String filePath}) async {
  var imageInUnit8List = await FlutterImageCompress.compressWithFile(
    filePath,
    quality: 50,
  );
  File compressedImage = File(filePath);
  compressedImage.writeAsBytesSync(imageInUnit8List!);
  return XFile(compressedImage.path);
}
