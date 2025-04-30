import 'package:absenpraujk/bloc/login/buttonlogin/buttonlogin_bloc.dart';
import 'package:absenpraujk/page/home/homepage.dart';
import 'package:absenpraujk/page/register.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:absenpraujk/utils/wiget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(child: Container()),
              Align(
                alignment: Alignment.center,
                child: Image.asset('assets/images/logo.png', height: 200),
              ),

              SizedBox(height: 30),
              const Text(
                'Log in ✨',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome back! Please enter your details.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              const Text('Email'),
              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
              const SizedBox(height: 16),
              const Text('Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } else if (state is ButtonloginFailed) {
                    popAlertLogin(
                      context,
                      lottieAddress: "assets/images/wrong.json",
                      title: state.message,
                      isAlert: true,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ButtonloginLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          context.read<ButtonloginBloc>().add(
                            ButtonloginHit(email: email, password: password),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
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

  Future<dynamic> popAlertLogin(
    BuildContext context, {
    required String lottieAddress,
    required String title,
    required bool isAlert,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: Container(
            width: double.infinity * 0.5,
            height: isAlert ? 390 : 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                Lottie.asset(
                  lottieAddress,
                  width: 100,
                  repeat: false,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 20),
                Text(
                  title,
                  // style: kanit20BoldMain,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                uniButton(
                  context,
                  title: Text("OK", style: TextStyle(color: Colors.white)),
                  func: () {
                    Navigator.pop(context);
                  },
                  warna: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
