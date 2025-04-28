import 'package:absenpraujk/bloc/riwayat/riwayatpage/riwayatpage_bloc.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  DateFormat dateFormat = DateFormat("EEEE, dd MMMM yyyy");
  DateFormat timeFormat = DateFormat("HH:mm");
  DateRangePickerController dateController = DateRangePickerController();
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
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      height: 700,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Filter Hari",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SfDateRangePicker(
                              // onSelectionChanged: _onSelectionChanged,
                              backgroundColor: Colors.white,
                              headerStyle: DateRangePickerHeaderStyle(
                                backgroundColor: Colors.white,
                              ),
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                              controller: dateController,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context.read<RiwayatpageBloc>().add(
                                    RiwayatFilter(
                                      filter:
                                          dateController.selectedDate ??
                                          DateTime.now(),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text("Terapkan"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Tutup"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
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
                        return ExpandableNotifier(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: <Widget>[
                                  ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: false,
                                    child: ExpandablePanel(
                                      theme: const ExpandableThemeData(
                                        headerAlignment:
                                            ExpandablePanelHeaderAlignment
                                                .center,
                                        tapBodyToCollapse: true,
                                      ),
                                      header: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          dateFormat.format(
                                            DateTime.parse(
                                              state
                                                  .listAbsen[index]
                                                  .masukDateTime
                                                  .toString(),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      collapsed: Container(),
                                      expanded: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 5),
                                          state
                                                      .listAbsen[index]
                                                      .pulangDateTime ==
                                                  null
                                              ? Row(
                                                children: [
                                                  Text(
                                                    timeFormat.format(
                                                      DateTime.parse(
                                                        state
                                                            .listAbsen[index]
                                                            .masukDateTime
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(" - "),
                                                  Text(
                                                    "Belum Pulang",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : Row(
                                                children: [
                                                  Text(
                                                    timeFormat.format(
                                                      DateTime.parse(
                                                        state
                                                            .listAbsen[index]
                                                            .masukDateTime
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(" - "),
                                                  Text(
                                                    timeFormat.format(
                                                      DateTime.parse(
                                                        state
                                                            .listAbsen[index]
                                                            .pulangDateTime
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          SizedBox(height: 10),
                                          Text(
                                            state.listAbsen[index].masukAddress
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                      builder: (_, collapsed, expanded) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: Expandable(
                                            collapsed: collapsed,
                                            expanded: expanded,
                                            theme: const ExpandableThemeData(
                                              crossFadePoint: 0,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        // return Card(
                        //   child: ListTile(
                        //     title: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        // Text(
                        //   dateFormat.format(
                        //     DateTime.parse(
                        //       state.listAbsen[index].masukDateTime
                        //           .toString(),
                        //     ),
                        //   ),
                        // ),
                        //         SizedBox(height: 5),
                        //         state.listAbsen[index].pulangDateTime == null
                        //             ? Row(
                        //               children: [
                        //                 Text(
                        //                   timeFormat.format(
                        //                     DateTime.parse(
                        //                       state
                        //                           .listAbsen[index]
                        //                           .masukDateTime
                        //                           .toString(),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Text(" - "),
                        //                 Text(
                        //                   "Belum Pulang",
                        //                   style: TextStyle(color: Colors.red),
                        //                 ),
                        //               ],
                        //             )
                        //             : Row(
                        //               children: [
                        //                 Text(
                        //                   timeFormat.format(
                        //                     DateTime.parse(
                        //                       state
                        //                           .listAbsen[index]
                        //                           .masukDateTime
                        //                           .toString(),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Text(" - "),
                        //                 Text(
                        //                   timeFormat.format(
                        //                     DateTime.parse(
                        //                       state
                        //                           .listAbsen[index]
                        //                           .pulangDateTime
                        //                           .toString(),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //       ],
                        //     ),
                        //     subtitle: Text(
                        //       state.listAbsen[index].masukAddress.toString(),
                        //     ),
                        //   ),
                        // );
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
