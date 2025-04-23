import 'package:absenpraujk/bloc/home/dashboard/dashbloc/dashboard_bloc.dart';
import 'package:absenpraujk/bloc/login/buttonlogin/buttonlogin_bloc.dart';
import 'package:absenpraujk/bloc/register/buttonregister/buttonregister_bloc.dart';
import 'package:absenpraujk/page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtonregisterBloc()),
        BlocProvider(create: (context) => ButtonloginBloc()),
        BlocProvider(create: (context) => DashboardBloc()),
      ],
      child: MaterialApp(
        title: 'AbsenPraujiKom',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LoginPage(),
      ),
    );
  }
}
