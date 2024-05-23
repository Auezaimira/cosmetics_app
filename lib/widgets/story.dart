import 'package:flutter/material.dart';

import 'story_view_page.dart';

class Story extends StatefulWidget {
  const Story({Key? key}) : super(key: key);

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> with TickerProviderStateMixin {
  late Animation<double> gap;
  late Animation<double> base;
  late Animation<double> reverse;
  late AnimationController controller;

  var model = [
    "https://images-static.nykaa.com/uploads/f5a1d948-7947-4241-a08e-caac8d991c48.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/c622c7aa-7cdb-43ba-98b7-acb48df7f7c5.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/fea188e3-9067-4c1f-a3a3-07560f60d73d.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/2f2275d3-0b85-4189-8fb3-7318ca1c3bec.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/9a4d3606-9aeb-4285-8db1-4918428a1c76.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/455bf3cd-82d4-4b2c-ab5d-e56491edc0f1.jpg?tr=w-300,cm-pad_resize",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);

    gap = Tween<double>(begin: 15.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: model.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) {
                        return StoryViewPage(model, index);
                      })),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: RotationTransition(
                                //it animates the rotation of widget
                                turns: base,
                                child: RotationTransition(
                                  turns: reverse,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage:
                                          NetworkImage(model[index]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )));
  }
}
