import 'package:flutter/material.dart';
import 'package:quizy/components/custom_button.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 30.0),
              height: screen.width / 3,
              width: screen.width / 3,
              child: const Image(
                image: AssetImage('assets/quiz-logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'quiz');
                },
                child: CustomButton(
                  text: 'Start Quiz!',
                  key: GlobalKey(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
