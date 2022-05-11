import 'package:alumni_app/services/media_query.dart';
import 'package:flutter/material.dart';

class ListItemsWidget extends StatelessWidget {
  final List listItems;
  final Function(int) removeTechElement;

  const ListItemsWidget({
    Key? key,
    required this.listItems,
    required this.removeTechElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < listItems.length; i += 2)
                SizedBox(
                  width: SizeData.screenWidth * .4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: SizeData.screenWidth * .4 - 25,
                        child: Text(
                          listItems[i],
                          style: Theme.of(context)
                              .textTheme.bodyText1
                              // .displayMedium!
                              
                              ?.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   listItems
                            //       .removeAt(i);
                            // });
                            removeTechElement(i);
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 1; i < listItems.length; i += 2)
                SizedBox(
                  width: SizeData.screenWidth * .4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: SizeData.screenWidth * .4 - 25,
                        child: Text(
                          listItems[i],
                          style: Theme.of(context)
                              .textTheme.bodyText1
                              // .displayMedium!
                              ?.copyWith(fontSize: 16),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            removeTechElement(i);
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
