import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:grand_flow/utils/contants.dart';
import 'package:grand_flow/utils/database_helper.dart';
import 'package:grand_flow/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      List<Map<String, dynamic>> users = await DatabaseHelper().getUsers();
      Map<String, dynamic>? user = users.firstWhere(
        (user) => user['email'] == _email && user['password'] == _password,
        orElse: () => {},
      );
      if (!mounted) return;
      if (user.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: user['id']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou senha inválidos'),
          ),
        );
      }
    }
  }

  void _loginAsGuest() {
    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return pleaseEnterYourEmail;
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return pleaseEnterYourPassword;
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Entrar'),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: _loginAsGuest,
                child: Text('Entrar como Convidado'),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: Text('Criar uma Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
