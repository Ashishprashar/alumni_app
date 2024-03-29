import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditableSocialIcons extends StatefulWidget {
  final String controllerText;
  final String socialName;

  final Function(TextEditingController) onControllerChanged;

  const EditableSocialIcons({
    Key? key,
    required this.controllerText,
    required this.socialName,
    required this.onControllerChanged,
  }) : super(key: key);

  @override
  State<EditableSocialIcons> createState() => _EditableSocialIconsState();
}

class _EditableSocialIconsState extends State<EditableSocialIcons> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController temporaryController;
  late IconData theicon;

  @override
  void dispose() {
    temporaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    temporaryController = TextEditingController(text: widget.controllerText);

    switch (widget.socialName) {
      case 'email':
        theicon = Icons.email;
        break;
      case 'twitter':
        theicon = FontAwesomeIcons.twitter;
        break;
      case 'linkedin':
        theicon = FontAwesomeIcons.linkedin;
        break;
      case 'facebook':
        theicon = FontAwesomeIcons.facebook;
        break;
      case 'instagram':
        theicon = FontAwesomeIcons.instagram;
        break;
      case 'github':
        theicon = FontAwesomeIcons.github;
        break;
    }
    return IconButton(
      icon: FaIcon(theicon),
      color: widget.controllerText == ''
          ? Colors.grey
          : Theme.of(context).appBarTheme.iconTheme!.color,
      onPressed: () {
        socialLink(widget.socialName, context, temporaryController);
      },
    );
  }

  dynamic socialLink(
    String socialName,
    BuildContext context,
    TextEditingController temporaryController,
  ) {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Padding(
                  // this padding is for the keyboard to not cover the text field
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add your $socialName profile link",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              "(make sure you add the \"https://\" part too.)",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Theme.of(context).focusColor)),
                              child: TextFormField(
                                controller: temporaryController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Eg: https://website.com/myprofile",
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  if (!(Uri.parse(value.trim()).isAbsolute)) {
                                    return 'invalid url';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    widget.onControllerChanged(
                                        temporaryController);
                                    // print(temporaryController.text);
                                    // if (mounted) {
                                    Navigator.pop(context);
                                    // }
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  // style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
