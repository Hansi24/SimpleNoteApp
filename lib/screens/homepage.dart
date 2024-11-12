import 'package:cw1/screens/mynotespage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff965C99),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(90, 50, 40, 5),
              child: Text(
                "MySimpleNote",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KyivType Sans',
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),

            Image.asset(
              "assets/book.png",
              width: 150,
              height: 150,
            ),

            // The button to navigate to Container3
            TextButton(
              onPressed: () {
                // Navigate to Container3 when the button is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mynotespage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 0, 6, 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                "Let's Get Started",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
