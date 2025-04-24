import 'package:absenpraujk/bloc/riwayat/riwayatpage/riwayatpage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  DateFormat dateFormat = DateFormat("EEEE, dd MMMM yyyy");
  DateFormat timeFormat = DateFormat("HH:mm");
  @override
  void initState() {
    super.initState();
    context.read<RiwayatpageBloc>().add(RiwayatpageInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absen'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            BlocConsumer<RiwayatpageBloc, RiwayatpageState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is RiwayatpageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RiwayatpageLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.listAbsen.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateFormat.format(
                                    DateTime.parse(
                                      state.listAbsen[index].masukDateTime
                                          .toString(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      timeFormat.format(
                                        DateTime.parse(
                                          state.listAbsen[index].masukDateTime
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    Text(" - "),
                                    Text(
                                      timeFormat.format(
                                        DateTime.parse(
                                          state.listAbsen[index].pulangDateTime
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Text(
                              state.listAbsen[index].masukAddress.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Failed To Load Data',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
