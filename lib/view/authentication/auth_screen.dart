
import 'package:flutter/material.dart';
import 'package:gitshiwam/constant/app_string.dart';
import 'package:gitshiwam/view/authentication/widgets/login.dart';
import 'package:gitshiwam/widget/widget.dart';



class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key, this.onAuthenticated}) : super(key: key);
  final VoidCallback? onAuthenticated;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizeExpandedSection(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppLogoWidget(
                          size: MediaQuery.of(context).size.width * 0.3),
                      const SizedBox(height: 20,),
                      const AppNameWidget(
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            const Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Login(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}



class AppNameWidget extends StatelessWidget {
  const AppNameWidget({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: size),
        children:  const [
          TextSpan(text: AppString.GIT),
          TextSpan(text: AppString.SHIWAM, style: TextStyle(fontWeight: FontWeight.bold)),
        ]));
  }
}

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppString.logo,
      height: size,
      width: size,
    );
  }
}