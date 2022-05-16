import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'done_button.dart';

class DeleteIcon extends StatefulWidget {
  const DeleteIcon({Key? key}) : super(key: key);

  @override
  State<DeleteIcon> createState() => _DeleteIconState();
}

class _DeleteIconState extends State<DeleteIcon> {
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUserProvider>(
        builder: (context, currentUserProvider, child) {
      return IconButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "You will loose all your data after this action!!!\nAre you sure?",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DoneButton(
                          height: 30,
                          width: 70,
                          text: "Yes",
                          onTap: () async {
                            Navigator.pop(context);
                            currentUserProvider.setDeleting();
                            await authServices.deleteAccount(context);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DoneButton(
                          height: 30,
                          width: 70,
                          text: "No",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                });

            // currentUserProvider.setDeleting();
          },
          icon: const Icon(Icons.delete));
    });
  }
}
