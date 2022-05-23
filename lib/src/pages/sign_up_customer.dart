import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';

class SignUpCustomerPage extends StatelessWidget {
  const SignUpCustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SignUpCustomerForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpCustomerForm extends StatefulWidget {
  const SignUpCustomerForm({Key? key}) : super(key: key);

  @override
  State<SignUpCustomerForm> createState() => _SignUpCustomerFormState();
}

class _SignUpCustomerFormState extends State<SignUpCustomerForm> {
  bool _passwordObscured = true;
  bool _passwordConfirmationObscured = true;
  bool isLoading = false;

  final _signUpCustomerFormKey = GlobalKey<FormState>();
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

  void _signUpCustomer() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (_signUpCustomerFormKey.currentState!.validate()) {
      _signUpCustomerFormKey.currentState!.save();
      try {
        await Server.signUpCustomer(_username!, _email!, _password!);
      } on ServerException catch (e) {
        if (!mounted) return;
        final snackBar = SnackBar(content: Text(e.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpCustomerFormKey,
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            onSaved: (value) => _username = value,
            validator: (value) => _validateUsername(value),
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
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
              border: OutlineInputBorder(),
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
                border: const OutlineInputBorder(),
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
                border: const OutlineInputBorder(),
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
                      onPressed: () => _signUpCustomer(),
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
