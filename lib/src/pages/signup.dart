import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _passwordObscured = true;
  bool _passwordConfirmationObscured = true;
  bool isLoading = false;

  final _signUpFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String? _username;
  String? _email;
  String? _password;

  String? _validateUsername(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (!RegExp(r"^[A-Za-z]+$").hasMatch(value.toLowerCase())) {
      return 'Please use only alphabetical characters';
    }
    return null;
  }

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
    if (value.length < 8) {
      return 'Password must contain 8 or more characters';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (_passwordController.text != value) {
      return 'Password confirmation must equal password';
    }
    return null;
  }

  void _signUp() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (_signUpFormKey.currentState!.validate()) {
      _signUpFormKey.currentState!.save();

      /*
      if (!mounted) return;

      if (result == null) {
        await _login();
        Navigator.pop(context);
      } else {
        final snackBar = SnackBar(content: Text(result));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }*/
    }

    setState(() {
      isLoading = false;
    });
  }

  /*
  Future<void> _login() async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    String? result = await Server.login(
        auth, _emailController.text, _passwordController.text);

    if (!mounted) return;

    if (result != null) {
      final snackBar = SnackBar(content: Text(result));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            onSaved: (value) => _username = value,
            validator: (value) => _validateUsername(value),
            decoration: const InputDecoration(
              labelText: 'Username',
              filled: true,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            textInputAction: TextInputAction.next,
            onSaved: (value) => _email = value,
            validator: (value) => _validateEmail(value),
            decoration: const InputDecoration(
              hintText: 'example@email.com',
              labelText: 'Email',
              filled: true,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _passwordController,
            obscureText: _passwordObscured,
            onSaved: (value) => _password = value,
            validator: (value) => _validatePassword(value),
            decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordObscured = !_passwordObscured;
                      });
                    },
                    icon: Icon(_passwordObscured
                        ? Icons.visibility_off
                        : Icons.visibility))),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: _passwordConfirmationObscured,
            validator: (value) => _validatePasswordConfirmation(value),
            decoration: InputDecoration(
                labelText: 'Password Confirmation',
                filled: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordConfirmationObscured =
                            !_passwordConfirmationObscured;
                      });
                    },
                    icon: Icon(_passwordConfirmationObscured
                        ? Icons.visibility_off
                        : Icons.visibility))),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('I already have an account'),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _signUp(),
                      child: const Text('Sign up'),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
