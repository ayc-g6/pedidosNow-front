import 'package:envios_ya/src/pages/signup.dart';
import 'package:flutter/material.dart';

class LogInBusinessPage extends StatelessWidget {
  const LogInBusinessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LogInBusinessForm(),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text('Sign up'),
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

class LogInBusinessForm extends StatefulWidget {
  const LogInBusinessForm({Key? key}) : super(key: key);

  @override
  State<LogInBusinessForm> createState() => _LogInBusinessFormState();
}

class _LogInBusinessFormState extends State<LogInBusinessForm> {
  bool _passwordObscured = true;
  bool isLoading = false;

  final _loginFormKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            onSaved: (value) => _email = value,
            validator: (value) => _validateEmail(value),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'example@email.com',
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _password = value,
            validator: (value) => _validatePassword(value),
            obscureText: _passwordObscured,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordObscured = !_passwordObscured;
                  });
                },
                icon: Icon(_passwordObscured
                    ? Icons.visibility_off
                    : Icons.visibility),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text('Sign in'),
                ),
        ],
      ),
    );
  }
}
