import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/utils/globals.dart';


getAppBar(double height, bool subject, String title, Color color) {
  return PreferredSize(
    preferredSize: Size.fromHeight(height*0.1),
    child: CustomAppBar(name: title, subject: subject, color: color,)
  );
}

getReturnAppBar(double height, bool subject, String title, Color color) {
  return PreferredSize(
    preferredSize: Size.fromHeight(height*0.1),
    child: ReturnAppBar(name: title, subject: subject, color: color,)
  );
}

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key, 
    required this.name, 
    required this.subject,
    required this.color
  }) : super(key: key);

  final String name;
  final bool subject;
  final Color color;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
       decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 2),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: SizedBox(height: 1,)),
                      if (widget.subject)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            builder: (context) => 
                            AlertDialog(
                              title: const Text('Fach ändern'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: CarouselSlider.builder(
                                  itemCount: lessons.length,
                                  options: CarouselOptions(
                                    scrollDirection: Axis.vertical,
                                    autoPlay: false,
                                    viewportFraction: 0.5,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        _currentIndex = index;
                                      });
                                    },
                                  ),
                                  itemBuilder: (context, index, _) {
                                    return Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: const BorderRadius.all(Radius.circular(12))
                                      ),
                                      child: Center(
                                        child: Text(
                                          lessons[index],
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Abbrechen',
                                    style: TextStyle(color: widget.color),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      lesson = lessons[_currentIndex];
                                    });
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(widget.color)
                                  ),
                                  child: const Text('Auswählen'),
                                ),
                              ],
                            ), 
                            context: context
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.change_circle_outlined,
                                    color: widget.color,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Fach: $lesson',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30
                        ),
                      )
                    ],
                  ),
                )
              ),
            )
          )
        ),
      ),
      centerTitle: false,
    );
  }
}


class ReturnAppBar extends AppBar {
  ReturnAppBar({
    Key? key, 
    required this.name, 
    required this.subject,
    required this.color
  }) : super(key: key);

  final String name;
  final bool subject;
  final Color color;

  @override
  State<ReturnAppBar> createState() => _ReturnAppBarState();
}

class _ReturnAppBarState extends State<ReturnAppBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          Container(
            width: double.infinity,
           decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 2),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 10, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: SizedBox(height: 1,)),
                          if (widget.subject)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                builder: (context) => 
                                AlertDialog(
                                  title: const Text('Fach ändern'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: CarouselSlider.builder(
                                      itemCount: lessons.length,
                                      options: CarouselOptions(
                                        scrollDirection: Axis.vertical,
                                        autoPlay: false,
                                        viewportFraction: 0.5,
                                        onPageChanged: (index, _) {
                                          setState(() {
                                            _currentIndex = index;
                                          });
                                        },
                                      ),
                                      itemBuilder: (context, index, _) {
                                        return Container(
                                          height: 60,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: const BorderRadius.all(Radius.circular(12))
                                          ),
                                          child: Center(
                                            child: Text(
                                              lessons[index],
                                              style: const TextStyle(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Abbrechen',
                                        style: TextStyle(color: widget.color),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          lesson = lessons[_currentIndex];
                                        });
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(widget.color)
                                      ),
                                      child: const Text('Auswählen'),
                                    ),
                                  ],
                                ), 
                                context: context
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.change_circle_outlined,
                                        color: widget.color,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Fach: $lesson',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                )
              )
            ),
          ),
          Positioned(
            left: 10.0, 
            bottom: 10.0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_back_ios,
                        color: widget.color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }
}