import 'package:absenpraujk/bloc/home/dashboard/dashbloc/dashboard_bloc.dart';
import 'package:absenpraujk/page/loginpage.dart';
import 'package:absenpraujk/service/db.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateFormat dateFormat = DateFormat("EEEE, dd MMMM yyyy");
  var idUser = "";
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    idUser = await PreferenceHandler.getId();
    // ignore: use_build_context_synchronously
    context.read<DashboardBloc>().add(DashboardInitialData(id: idUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              PreferenceHandler.removeId();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardFailed) {
            return Center(child: Text("Failed Load Data"));
          } else if (state is DashboardLoaded) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Selamat datang di aplikasi absen \n ${state.user.name}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  dateFormat.format(DateTime.now()),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 20),
                DigitalClock(
                  showSeconds: true,
                  datetime: DateTime.now(),
                  digitalClockTextColor: Colors.black,
                  textScaleFactor: 1.3,
                  isLive: true,
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Sedang Berada : \n ${state.currentAddress}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Dbhelper dbHelper = Dbhelper();

                            Map<String, dynamic> absenData = {
                              'userId': idUser,
                              'masukDateTime': DateTime.now().toString(),
                              'masukLat': state.currentLat,
                              'masukLong': state.currentLong,
                              'masukAddress': state.currentAddress,
                            };
                            String result = await dbHelper.insertAbsenMasuk(
                              data: absenData,
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(result)));
                          },
                          child: Text('Absen Masuk'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Create an instance of Dbhelper
                            Dbhelper dbHelper = Dbhelper();
                            // // Prepare the data for absen
                            Map<String, dynamic> absenData = {
                              'pulangDateTime': DateTime.now().toString(),
                              'pulangLat':
                                  state
                                      .currentLat, // Assuming `state.currentLat` contains latitude
                              'pulangLong':
                                  state
                                      .currentLong, // Assuming `state.currentLong` contains longitude
                              'pulangAddress':
                                  state
                                      .currentAddress, // Assuming `state.currentAddress` contains the address
                            };
                            // print(absenData);
                            String result = await dbHelper.insertAbsenPulang(
                              data: absenData,
                              userId: int.parse(idUser),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(result)));
                          },
                          child: Text('Absen Pulang'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: Text("Failed Load Data"));
        },
      ),
    );
  }
}
