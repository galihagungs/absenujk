import 'package:absenpraujk/bloc/login/buttonlogin/buttonlogin_bloc.dart';
import 'package:absenpraujk/page/home/homepage.dart';
import 'package:absenpraujk/page/register.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() async {
    var id = await PreferenceHandler.getId();
    if (id != '') {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan email anda';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Tolong masukan email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan password anda';
                  }
                  if (value.length < 6) {
                    return 'Tolong masukan password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text("Daftar"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              BlocConsumer<ButtonloginBloc, ButtonloginState>(
                listener: (context, state) {
                  if (state is ButtonloginSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } else if (state is ButtonloginError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is ButtonloginLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        context.read<ButtonloginBloc>().add(
                          ButtonloginHit(email: email, password: password),
                        );
                      }
                    },
                    child: Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
