import 'package:flutter/material.dart';
import 'package:study_smart/pages/subprofile/edit_profile.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: getAppBar(height, false, 'Profil', mainGreenScheme),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              ButtonBox(
                color: mainGreenScheme, 
                width: width * 0.9, 
                icon: const Icon(Icons.settings_outlined), 
                text: 'Konto bearbeiten', 
                onTap: () {
                  Navigator.push(
                    context,
                    SwipeRightTransition(
                      widget: const EditProfile(),
                    ),
                  );
                }
              ),
              const SizedBox(height: 10),
              CustomBox(
                  color: mainGreenScheme,
                  height: 150,
                  width: width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kontoinformationen',
                          style: TextStyle(color: mainFontColor, fontSize: 18),
                        ),
                        Divider(
                          color: mainFontColor,
                          thickness: 2,
                          endIndent: 30,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainFontColor),
                            ),
                            Text(
                              '$firstName $lastName',
                              style: TextStyle(color: mainFontColor),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Email: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainFontColor),
                            ),
                            Text(
                              email,
                              style: TextStyle(color: mainFontColor),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Nutzer seit: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainFontColor),
                            ),
                            Text(
                              '${joined.year}-${joined.month}-${joined.day}',
                              style: TextStyle(color: mainFontColor),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )),
              const SizedBox(height: 15),
              CustomBox(
                color: mainGreenScheme,
                height: 200,
                width: width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lernfortschritt',
                        style: TextStyle(color: mainFontColor, fontSize: 18),
                      ),
                      Divider(
                        color: mainFontColor,
                        thickness: 2,
                        endIndent: 30,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomProgressIndicator(
                          currentValue: minutesLearned*5 + answersGiven*15 + questionsAsked*10 + exercisesSolved*5, 
                          maxValue: 100
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${((minutesLearned*5 + answersGiven*15 + questionsAsked*10 + exercisesSolved*5).toString())}xp'
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
              ),
              const SizedBox(height: 15),
              CustomBox(
                color: mainGreenScheme,
                height: 170,
                width: width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erfolge',
                        style: TextStyle(color: mainFontColor, fontSize: 18),
                      ),
                      Divider(
                        color: mainFontColor,
                        thickness: 2,
                        endIndent: 30,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Fragen gestellt: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainFontColor),
                          ),
                          Text(
                            questionsAsked.toString(),
                            style: TextStyle(color: mainFontColor),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Antworten gegeben: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainFontColor),
                          ),
                          Text(
                            answersGiven.toString(),
                            style: TextStyle(color: mainFontColor),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Aufgaben bearbeitet: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainFontColor),
                          ),
                          Text(
                            exercisesSolved.toString(),
                            style: TextStyle(color: mainFontColor),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Zeit gelernt: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainFontColor),
                          ),
                          Text(
                            minutesLearned.toString(),
                            style: TextStyle(color: mainFontColor),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
              ),
              const SizedBox(height: 80)
            ],
          ),
        ),
      ),
    );
  }
}


class CustomProgressIndicator extends StatelessWidget {
  final int currentValue;
  final int maxValue;

  const CustomProgressIndicator({
    Key? key,
    required this.currentValue,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentValue / maxValue;
    int level = (progress).ceil();
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (level - 1).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
            Text(
              (level).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            )
          ],
        ),
        Container(
          width: width,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: mainGreenScheme, width: 2)
          ),
          child: Stack(
            children: [
              Container(
                width: width * (progress-level+1),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: mainGreenScheme,
                ),
              ),
              /*if (level < 4)
                Positioned.fill(
                  right: 0,
                  child: Container(
                    width: 5,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.grey[300],
                    ),
                  ),
                ),*/
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${((level - 1) * 100).toString()}xp',
              style: const TextStyle(
                fontSize: 12
              ),
            ),
            Text(
              '${(level * 100).toString()}xp',
              style: const TextStyle(
                fontSize: 12
              ),
            )
          ],
        ),
      ],
    );
  }
}
