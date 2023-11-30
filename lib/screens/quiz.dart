import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:quizy/components/quiz_option.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List? questions; // Add a "?" to make it nullable
  String? currentTitle; // Add a "?" to make it nullable
  String? currentCorrectAnswer; // Add a "?" to make it nullable
  List<dynamic>? currentAnswers; // Add a "?" to make it nullable
  int? corrects; // Add a "?" to make it nullable
  int? currentQuestion; // Add a "?" to make it nullable
  int? selectedAnswer; // Add a "?" to make it nullable
  DateTime? now;

  @override
  void initState() {
    now = DateTime.now();
    corrects = 0;
    currentQuestion = 0;
    questions = null;
    selectedAnswer = null;
    getQuestions();
    super.initState();
  }

  void getQuestions() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://opentdb.com/api.php?amount=10&difficulty=medium&type=multiple'),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List answers = [data['results'][0]['correct_answer']] +
            data['results'][0]['incorrect_answers'];
        setState(() {
          questions = data['results'];
          currentTitle = data['results'][0]['question'];
          currentCorrectAnswer = data['results'][0]['correct_answer'];
          currentAnswers = answers..shuffle();
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      print('Error fetching questions: $error');
      // Handle the error accordingly
    }
  }

  void verifyAndNext(BuildContext context) {
    String textSelectAnswer = currentAnswers![selectedAnswer!];
    if (textSelectAnswer == currentCorrectAnswer) {
      setState(() {
        corrects = (corrects ?? 0) + 1;
      });
    }
    nextQuestion(context);
  }

  void nextQuestion(BuildContext context) {
    int actualQuestion = currentQuestion!;
    if (actualQuestion + 1 < questions!.length) {
      List answers = [questions![actualQuestion + 1]['correct_answer']] +
          questions![actualQuestion + 1]['incorrect_answers'];
      setState(() {
        currentQuestion = actualQuestion + 1;
        currentTitle = questions![actualQuestion + 1]['question'];
        currentCorrectAnswer = questions![actualQuestion + 1]['correct_answer'];
        currentAnswers = answers..shuffle();
        selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacementNamed(context, 'result', arguments: {
        'corrects': corrects,
        'start_at': now,
        'list_length': questions!.length,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: (questions != null)
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, 'start');
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Question ${currentQuestion! + 1}',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/${questions!.length}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      margin: const EdgeInsets.symmetric(vertical: 30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        HtmlUnescape().convert(currentTitle!),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentAnswers!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == currentAnswers!.length) {
                            return GestureDetector(
                              onTap: () {
                                if (selectedAnswer != null) {
                                  verifyAndNext(context);
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 30.0,
                                ),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: (selectedAnswer == null)
                                      ? Colors.grey
                                      : theme.primaryColor,
                                  borderRadius: BorderRadius.circular(180.0),
                                ),
                                child: const Text(
                                  'Next',
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }
                          String answer = currentAnswers![index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAnswer = index;
                              });
                            },
                            child: QuizOption(
                              index: index,
                              selectedAnswer: selectedAnswer!,
                              answer: answer,
                              key: GlobalKey(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.primaryColor,
                  ),
                ),
              ),
      ),
    );
  }
}
