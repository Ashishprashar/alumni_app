import 'package:alumni_app/services/media_query.dart';
import 'package:flutter/material.dart';

class TechStackWidget extends StatelessWidget {
  final List techStackList;
  final Function(int) removeTechElement;

  const TechStackWidget({
    Key? key,
    required this.techStackList,
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
              for (int i = 0; i < techStackList.length; i += 2)
                SizedBox(
                  width: SizeData.screenWidth * .4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(techStackList[i]),
                      GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   techStackList
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
              for (int i = 1; i < techStackList.length; i += 2)
                SizedBox(
                  width: SizeData.screenWidth * .4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(techStackList[i]),
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