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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  onProfileChanged!(File(image.path));
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FaIcon(FontAwesomeIcons.camera),
                  Text("Camera")
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  onProfileChanged!(File(image.path));
                }
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FaIcon(FontAwesomeIcons.camera),
                  Text("Gallery")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
