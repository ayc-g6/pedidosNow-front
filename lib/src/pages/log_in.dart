import 'package:envios_ya/src/pages/log_in_business.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Log In as Business'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LogInBusinessPage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Log In as Customer'),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Log In as Delivery'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
