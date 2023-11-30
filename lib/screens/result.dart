import 'package:flutter/material.dart';
import 'package:quizy/components/custom_button.dart';

class Result extends StatelessWidget {
  const Result({super.key, Key? ke});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screen = MediaQuery.of(context).size;
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    int time = 0; // Initialize time with a default value

    if (args != null && args.containsKey('start_at')) {
      time = DateTime.now().difference(args['start_at'] as DateTime).inSeconds;
    } else {
      // Handle the case when args or 'start_at' is null
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screen.width - 40.0,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(6.0, 12.0),
                    blurRadius: 6.0,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screen.width / 3.5,
                    width: screen.width / 3.5,
                    child: Image(
                      image: AssetImage((args != null && args['corrects'] >= 5)
                          ? 'assets/celebrate.png'
                          : 'assets/repeat.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      (args != null && args['corrects'] >= 5)
                          ? 'Congratulations!!'
                          : 'Completed!',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      (args != null && args['corrects'] >= 5)
                          ? 'You are amazing!!'
                          : 'Better luck next time!',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Text(
                    '${args != null ? args['corrects'] : 0}/${args != null ? args['list_length'] : 0} correct answers in $time seconds.',
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'start');
                    },
                    child: CustomButton(
                      text: 'Play Again',
                      key: GlobalKey(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
