import 'package:absenpraujk/bloc/home/dashboard/dashbloc/dashboard_bloc.dart';
import 'package:absenpraujk/bloc/login/buttonlogin/buttonlogin_bloc.dart';
import 'package:absenpraujk/bloc/profile/page/profilepage_bloc.dart';
import 'package:absenpraujk/bloc/register/buttonregister/buttonregister_bloc.dart';
import 'package:absenpraujk/bloc/riwayat/riwayatpage/riwayatpage_bloc.dart';
import 'package:absenpraujk/page/loginpage.dart';
import 'package:absenpraujk/utils/theme.dart';
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
        BlocProvider(create: (context) => ProfilepageBloc()),
        BlocProvider(create: (context) => RiwayatpageBloc()),
      ],
      child: MaterialApp(
        title: 'AbsenPraujiKom',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
        ),
        // themeMode: ThemeMode.dark,
        home: LoginPage(),
      ),
    );
  }
}
