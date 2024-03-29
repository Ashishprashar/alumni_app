import 'package:alumni_app/provider/search_provider.dart';
import 'package:alumni_app/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    Provider.of<SearchProvider>(context, listen: false)
        .addListenerToScrollController();
    Provider.of<SearchProvider>(context, listen: false).searchPeople();
    super.initState();
  }

  @override
  void dispose() {
    // Provider.of<SearchProvider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          searchProvider.dispose();
          searchProvider.clearSearchController();
          return true;
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                elevation: 0,
                title: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    // maxLength: 30,
                    style: Theme.of(context).textTheme.bodyText2,
                    autofocus: true,
                    // style: TextStyle(backgroundColor: Colors.grey),
                    controller: searchProvider.searchController,
                    onChanged: (v) {
                      if (v.isEmpty) {
                        searchProvider.searchPeople(isFilter: true);
                      }
                    },
                    onSubmitted: (value) =>
                        searchProvider.searchPeople(isFilter: true),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).selectedRowColor,
                      filled: true,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      // prefixIcon: const Icon(Icons.search),
                      // suffixIcon: searchProvider.searchController.text.isNotEmpty
                      //     ? InkWell(
                      //         onTap: () {
                      //           searchProvider.clearSearchController();
                      //         },
                      //         child: const Icon(
                      //           Icons.close,
                      //           size: 25,
                      //           color: Colors.grey,
                      //         ),
                      //       )
                      //     : null,
                      hintText: 'Search by name',

                      suffixIcon: IconButton(
                        onPressed: () {
                          searchProvider.searchPeople(isFilter: true);
                        },
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).toggleableActiveColor,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: ListView(
                  controller: searchProvider.scrollController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Branch",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Container(
                                width: 20,
                              ),
                              DropdownButton(
                                hint: searchProvider.defaultBranchValue == null
                                    ? const Text("All")
                                    : Text(
                                        searchProvider.defaultBranchValue!,
                                        // style: const TextStyle(
                                        //     color: Colors.blue),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                value: searchProvider.defaultBranchValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: searchProvider.possibleBranches
                                    .map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    searchProvider.defaultBranchValue =
                                        newValue == "All" ? null : newValue!;
                                  });
                                  searchProvider.searchPeople(isFilter: true);
                                },
                              ),
                            ],
                          ),
                        ),
                        //Sem
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
                                hint: searchProvider.defaultSemesterValue ==
                                        null
                                    ? const Text("All")
                                    : Text(
                                        searchProvider.defaultSemesterValue!,
                                        // style: const TextStyle(
                                        //     color: Colors.blue),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                value: searchProvider.defaultSemesterValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: searchProvider.possibleSemesters
                                    .map((String items) {
                                  return DropdownMenuItem<String>(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    searchProvider.defaultSemesterValue =
                                        newValue == "All" ? null : newValue!;
                                  });
                                  searchProvider.searchPeople(isFilter: true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (searchProvider.peopleList.length > 0)
                      for (int i = 0; i < searchProvider.peopleList.length; i++)
                        UserCard(index: i, snapshot: searchProvider.peopleList)
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'No matches.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    // ListView.builder(
                    //   itemCount: searchProvider.peopleList.length,
                    //   controller: searchProvider.scrollController,
                    //   itemBuilder: (context, index) {
                    //     return
                    //   },
                    // ),
                  ],
                ),
              )),
        ),
      );
    });
  }
}
