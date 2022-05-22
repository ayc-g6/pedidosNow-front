import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';

class SignUpBusinessPage extends StatelessWidget {
  const SignUpBusinessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SignUpBusinessForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpBusinessForm extends StatefulWidget {
  const SignUpBusinessForm({Key? key}) : super(key: key);

  @override
  State<SignUpBusinessForm> createState() => _SignUpBusinessFormState();
}

class _SignUpBusinessFormState extends State<SignUpBusinessForm> {
  bool _passwordObscured = true;
  bool _passwordConfirmationObscured = true;
  bool isLoading = false;

  final _signUpBusinessFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String? _businessName;
  String? _address;
  String? _email;
  String? _password;

  String? _validateBusinessName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid business name';
    }
    return null;
  }

  String? _validateAddress(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid address';
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

  void _signUpBusiness() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (_signUpBusinessFormKey.currentState!.validate()) {
      _signUpBusinessFormKey.currentState!.save();
      try {
        //Server.signUp(_email!, _password!);
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
      key: _signUpBusinessFormKey,
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            onSaved: (value) => _businessName = value,
            validator: (value) => _validateBusinessName(value),
            decoration: const InputDecoration(
              labelText: 'Business Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            textInputAction: TextInputAction.next,
            onSaved: (value) => _address = value,
            validator: (value) => _validateAddress(value),
            decoration: const InputDecoration(
              labelText: 'Address',
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
                border: OutlineInputBorder(),
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
                      onPressed: () => _signUpBusiness(),
                      child: const Text('SIGN UP'),
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
