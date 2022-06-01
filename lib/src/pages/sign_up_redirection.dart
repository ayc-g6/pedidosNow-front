import 'package:envios_ya/src/pages/sign_up.dart';
import 'package:flutter/material.dart';

class SignUpRedirectionPage extends StatelessWidget {
  const SignUpRedirectionPage({Key? key}) : super(key: key);

  List<Widget> buildSignUpButtons(BuildContext context) {
    return [
      Text(
        "Sign up as...",
        style: Theme.of(context).textTheme.headline6,
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: const Text('Business'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignUpPage(
                  accountType: Account.business,
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: const Text('Customer'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignUpPage(
                  accountType: Account.customer,
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: const Text('Delivery'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignUpPage(
                  accountType: Account.delivery,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                              image: AssetImage('images/enviosya_logo.png')),
                          const SizedBox(height: 64.0),
                          ...buildSignUpButtons(context),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Sign in'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
