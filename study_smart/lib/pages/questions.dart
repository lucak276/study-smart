import 'package:flutter/material.dart';
import 'package:study_smart/pages/subquestions/answer_question.dart';
import 'package:study_smart/pages/subquestions/ask_question.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

// Define a custom Form widget.
class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  QuestionPageState createState() {
    return QuestionPageState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class QuestionPageState extends State<QuestionPage> {
  bool _showMyQuestions = true;
  bool _showOtherQuestions = true;
  List<Widget> myQuestionWidget = [];
  List<Widget> questionWidget = [];

  @override
  void initState() {
    super.initState();

    fetchQuestions();
  }

  fetchQuestions() {
    try {
      for (var question in myQuestions) {
        myQuestionWidget.add(_getQuestionBox(question));
      }
      for (var question in questions) {
        questionWidget.add(_getQuestionBox(question));
      }
    } catch (e) {
      return;
    }
  }

  Widget _getQuestionBox(Question question) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SwipeRightTransition(
            widget: AnswerQuestion(
              question: question,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomBox(
            color: mainPurpleScheme,
            height: 120,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.title,
                      style: TextStyle(color: mainFontColor, fontSize: 18),
                    ),
                    Divider(
                      color: mainFontColor,
                      thickness: 2,
                      endIndent: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question.description,
                      style: TextStyle(color: mainFontColor),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: getAppBar(height, true, 'Fragen', mainPurpleScheme),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ButtonBox(
                  text: 'Frage stellen',
                  color: mainPurpleScheme,
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: mainFontColor,
                  ),
                  width: double.infinity,
                  onTap: () {
                    Navigator.push(
                      context,
                      SwipeRightTransition(
                        widget: const AskQuestion(),
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showMyQuestions = !_showMyQuestions;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showMyQuestions
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Meine Fragen:',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]),
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            _showMyQuestions
                ? Column(
                    children: myQuestionWidget,
                  )
                : const SizedBox(
                    height: 1,
                  ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOtherQuestions = !_showOtherQuestions;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showOtherQuestions
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Andere Fragen:',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]),
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            _showOtherQuestions
                ? Column(
                    children: questionWidget,
                  )
                : const SizedBox(
                    height: 1,
                  )
            /*
              _showMyQuestions
              ? Column(
                children: taskWidgets,
              )
              : const SizedBox(height: 5),
              */
          ]),
        ));
  }
}

class Question {
  final String title;
  final String id;
  final String description;
  final String imagePath;
  final DateTime createdAt;

  const Question(
      {required this.title,
      required this.description,
      required this.createdAt,
      required this.imagePath,
      required this.id});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'imagePath': imagePath,
      'id': id
    };
    return map;
  }

  factory Question.fromMap(Map<dynamic, dynamic> data) {
    Question question = Question(
        title: data['title'],
        description: data['description'],
        createdAt: toDateTime(data['createdAt']),
        imagePath: data['imagePath'],
        id: data['id']);
    return question;
  }
}
