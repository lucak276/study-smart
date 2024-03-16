import 'package:flutter/material.dart';
import 'package:study_smart/pages/questions.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/pages/overview.dart';
import 'package:study_smart/pages/profile.dart';
import 'package:study_smart/pages/tasks.dart';
import 'package:study_smart/utils/globals.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final List<Widget> _widgetOptions = <Widget>[
    const Exercise(),
    const QuestionPage(),
    const Overview(),
    const Tasks(),
    const Profile(),
  ];

  int selectedIndex = 2;

  void _onItemTapped(int index) async {
    setState(() {
      switch (index) {
        case 0:
          mainColorScheme = mainYellowScheme;
          break;
        case 1:
          mainColorScheme = mainPurpleScheme;
          break;
        case 2:
          mainColorScheme = mainBlueScheme;
          break;
        case 3:
          mainColorScheme = mainRedScheme;
          break;
        case 4:
          mainColorScheme = mainGreenScheme;
          break;
        default:
      }
      selectedIndex = index;
    });
  }

  Widget navBar() {
    return Container(
        decoration: BoxDecoration(
            color: mainColorScheme,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        // color: mainColorScheme,
        child: Material(
          //color: Colors.black,
          elevation: 0.0,

          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: mainColorScheme,
                  icon: const ImageIcon(
                    AssetImage('assets/icons/people-fill.png'),
                    //color: Colors.black,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  backgroundColor: mainColorScheme,
                  icon: const Icon(Icons.question_mark),
                  //color: Colors.black,

                  label: '',
                ),
                BottomNavigationBarItem(
                  backgroundColor: mainColorScheme,
                  icon: const ImageIcon(
                      AssetImage('assets/icons/house-door-fill.png')),
                  label: '',
                ),
                BottomNavigationBarItem(
                  backgroundColor: mainColorScheme,
                  icon: const ImageIcon(
                      AssetImage('assets/icons/clipboard-fill.png')),
                  label: '',
                ),
                BottomNavigationBarItem(
                  backgroundColor: mainColorScheme,
                  icon: const ImageIcon(
                      AssetImage('assets/icons/person-fill.png')),
                  label: '',
                ),
              ],
              currentIndex: selectedIndex,
              backgroundColor: mainColorScheme,
              selectedItemColor: headerNavFontColor,
              unselectedItemColor: Colors.white70,
              onTap: _onItemTapped),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorScheme,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: navBar(),
    );
  }
}
