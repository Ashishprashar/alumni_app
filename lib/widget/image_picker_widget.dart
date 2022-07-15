import 'package:alumni_app/utilites/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  // callback function
  final Function(File?)? onProfileChanged;
  const ImagePickerWidget({
    Key? key,
    @required this.onProfileChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePicker imagePicker = ImagePicker();
    return Dialog(
      child: SizedBox(
        height: 70,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  XFile? image =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    final compressedImage =
                        await compressImage(filePath: image.path);
            
                    onProfileChanged!(File(compressedImage.path));
                    Navigator.of(context).pop();
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const FaIcon(FontAwesomeIcons.camera),
                    Text(
                      "Camera",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  XFile? image =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final compressedImage =
                        await compressImage(filePath: image.path);
            
                    onProfileChanged!(File(compressedImage.path));
                  }
                  Navigator.of(context).pop();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const FaIcon(FontAwesomeIcons.camera),
                    Text(
                      "Gallery",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
