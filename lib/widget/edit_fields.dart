import 'package:alumni_app/provider/edit_screen_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:alumni_app/widget/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFields extends StatefulWidget {
  const EditFields({Key? key}) : super(key: key);

  @override
  State<EditFields> createState() => _EditFieldsState();
}

class _EditFieldsState extends State<EditFields> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditScreenProvider>(
        builder: (context, editProvider, child) {
      return Column(
        children: [
          const SizedBox(height: 20),
          // CustomTextField(
          //   controller: editProvider.nameController,
          //   title: "Name",
          // ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bio',
                ),
                Container(
                  // height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Theme.of(context).focusColor)),
                  child: Center(
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyText1,
                      controller: editProvider.bioController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tell us about you',
                        // suffixIcon: suffix,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20),
          // CustomTextField(
          //   controller: editProvider.usnController,
          //   title: "Usn",
          // ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: editProvider.skillsController,
            title: "Skills",
            hint: 'Add Something',
            suffix: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  if (editProvider.skillsController.text != '') {
                    editProvider.tempSkillsList
                        .insert(0, editProvider.skillsController.text);
                  }
                });
                editProvider.skillsController.text = "";
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).hoverColor,
                size: 30,
              ),
            ),
          ),
          ListItemsWidget(
            listItems: editProvider.tempSkillsList,
            removeTechElement: (int i) {
              setState(() {
                editProvider.tempSkillsList.removeAt(i);
              });
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: editProvider.interestsController,
            title: "Interests",
            hint: 'Add Something',
            suffix: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  if (editProvider.interestsController.text != '') {
                    editProvider.tempInterestsList
                        .insert(0, editProvider.interestsController.text);
                  }
                });
                editProvider.interestsController.text = "";
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).hoverColor,
                size: 30,
              ),
            ),
          ),
          ListItemsWidget(
              listItems: editProvider.tempInterestsList,
              removeTechElement: (int i) {
                setState(() {
                  editProvider.tempInterestsList.removeAt(i);
                });
              }),

          const SizedBox(height: 20),
          CustomTextField(
            controller: editProvider.favoriteMusicController,
            title: "Favorite Music",
            hint: 'Add Something',
            suffix: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  if (editProvider.favoriteMusicController.text != '') {
                    editProvider.tempFavoriteMusicList
                        .insert(0, editProvider.favoriteMusicController.text);
                  }
                });
                editProvider.favoriteMusicController.text = "";
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).hoverColor,
                size: 30,
              ),
            ),
          ),
          ListItemsWidget(
              listItems: editProvider.tempFavoriteMusicList,
              removeTechElement: (int i) {
                setState(() {
                  editProvider.tempFavoriteMusicList.removeAt(i);
                });
              }),
          const SizedBox(height: 20),
          CustomTextField(
            controller: editProvider.favoriteShowsMoviesController,
            title: "Favorite Shows/Movies",
            hint: 'Add Something',
            suffix: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  if (editProvider.favoriteShowsMoviesController.text != '') {
                    editProvider.tempFavoriteShowsMoviesList.insert(
                        0, editProvider.favoriteShowsMoviesController.text);
                  }
                });
                editProvider.favoriteShowsMoviesController.text = "";
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).hoverColor,
                size: 30,
              ),
            ),
          ),
          ListItemsWidget(
              listItems: editProvider.tempFavoriteShowsMoviesList,
              removeTechElement: (int i) {
                setState(() {
                  editProvider.tempFavoriteShowsMoviesList.removeAt(i);
                });
              }),
          const SizedBox(height: 10),

          //Gender
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Text(
                  "Gender",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: 33,
                ),
                DropdownButton(
                  hint: editProvider.defaultGender == null
                      ? Text(currentUser!.gender)
                      : Text(
                          editProvider.defaultGender!,
                          // style: const TextStyle(
                          //     color: Colors.blue),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  value: editProvider.defaultGender,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: editProvider.possibleGenders.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      editProvider.defaultGender = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),

          //branch
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Text(
                  "Branch",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: 35,
                ),
                DropdownButton(
                  hint: editProvider.defaultBranchValue == null
                      ? Text(currentUser!.branch)
                      : Text(
                          editProvider.defaultBranchValue!,
                          // style: const TextStyle(
                          //     color: Colors.blue),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  value: editProvider.defaultBranchValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: editProvider.possibleBranches.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      editProvider.defaultBranchValue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          //Sem
          if (currentUser!.status == 'Student')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Text(
                    "Semester",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Container(
                    width: 20,
                  ),
                  DropdownButton(
                    hint: editProvider.defaultSemesterValue == null
                        ? Text(currentUser!.semester)
                        : Text(
                            editProvider.defaultSemesterValue!,
                            // style: const TextStyle(
                            //     color: Colors.blue),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                    value: editProvider.defaultSemesterValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: editProvider.possibleSemesters.map((String items) {
                      return DropdownMenuItem<String>(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        editProvider.defaultSemesterValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
