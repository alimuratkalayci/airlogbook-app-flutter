import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../sign_in_page/sign_in_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Flexible(
              flex: 4,
              child: Lottie.network(
                'https://lottie.host/20f33894-3c18-41e9-97b3-b7f67b2d192d/haVgTZj3TT.json', // Lottie animation URL
                width: screenWidth * 1,
                height: screenHeight * 1,
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Text(
                "Welcome to our log book app",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff28397f),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Text(
                "Record and report \nyour flights as you wish.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.64),
                ),
              ),
            ),
            const Spacer(flex: 2),
            FittedBox(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Color(0xff28397f),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xff28397f),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
