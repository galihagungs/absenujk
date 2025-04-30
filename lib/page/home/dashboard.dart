import 'package:absenpraujk/bloc/home/dashboard/dashbloc/dashboard_bloc.dart';
import 'package:absenpraujk/page/loginpage.dart';
import 'package:absenpraujk/service/db.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:absenpraujk/utils/wiget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
      // backgroundColor: Colors.black,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardFailed) {
            return Center(child: Text("Failed Load Data"));
          } else if (state is DashboardLoaded) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    height: 70,
                                  ),
                                ),
                                Text(
                                  "AbsenKu",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                PreferenceHandler.removeId();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hallo, ${state.user.name}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Selamat datang di aplikasi AbsenKu',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DigitalClock(
                      showSeconds: true,
                      datetime: DateTime.now(),
                      digitalClockTextColor: Colors.white,
                      textScaleFactor: 1.3,
                      isLive: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    child: GoogleMap(
                      circles: <Circle>{
                        Circle(
                          circleId: const CircleId("circle"),
                          center: LatLng(state.currentLat, state.currentLong),
                          radius: 1,
                          fillColor: Colors.blue.withOpacity(0.5),
                          strokeWidth: 2,
                          strokeColor: Colors.blue,
                        ),
                      },
                      compassEnabled: true,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(state.currentLat, state.currentLong),
                        zoom: 18.4746,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Absen Hari Ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            dateFormat.format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Lokasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            state.currentAddress,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Dbhelper dbHelper = Dbhelper();

                                    Map<String, dynamic> absenData = {
                                      'userId': idUser,
                                      'masukDateTime':
                                          DateTime.now().toString(),
                                      'masukLat': state.currentLat,
                                      'masukLong': state.currentLong,
                                      'masukAddress': state.currentAddress,
                                    };
                                    String result = await dbHelper
                                        .insertAbsenMasuk(data: absenData);
                                    if (result ==
                                        "Absen Masuk berhasil ditambahkan") {
                                      popAlertDash(
                                        context,
                                        lottieAddress:
                                            "assets/images/check.json",
                                        title: result,
                                        isAlert: false,
                                      );
                                    } else if (result ==
                                        "Anda Sudah Absen Hari Ini") {
                                      popAlertDash(
                                        context,
                                        lottieAddress:
                                            "assets/images/information.json",
                                        title: result,
                                        isAlert: false,
                                      );
                                    } else {
                                      popAlertDash(
                                        context,
                                        lottieAddress:
                                            "assets/images/wrong.json",
                                        title: result,
                                        isAlert: false,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Absen Masuk',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Dbhelper dbHelper = Dbhelper();

                                    Map<String, dynamic> absenData = {
                                      'pulangDateTime':
                                          DateTime.now().toString(),
                                      'pulangLat': state.currentLat,
                                      'pulangLong': state.currentLong,
                                      'pulangAddress': state.currentAddress,
                                    };
                                    // print(absenData);
                                    String result = await dbHelper
                                        .insertAbsenPulang(
                                          data: absenData,
                                          userId: int.parse(idUser),
                                        );
                                    if (result == "Absen Pulang berhasil") {
                                      popAlertDash(
                                        context,
                                        lottieAddress:
                                            "assets/images/check.json",
                                        title: result,
                                        isAlert: false,
                                      );
                                    } else if (result ==
                                        "Anda Sudah Absen Pulang Hari Ini") {
                                      popAlertDash(
                                        context,
                                        lottieAddress:
                                            "assets/images/information.json",
                                        title: result,
                                        isAlert: false,
                                      );
                                    } else {
                                      popAlertDash(
                                        context,
                                        lottieAddress:
                                            "assets/images/wrong.json",
                                        title: result,
                                        isAlert: false,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.output, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        'Absen Pulang',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  Future<dynamic> popAlertDash(
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
            width: double.infinity,
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
