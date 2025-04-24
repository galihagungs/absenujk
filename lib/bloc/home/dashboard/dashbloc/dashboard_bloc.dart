import 'dart:math';

import 'package:absenpraujk/model/UserModel.dart';
import 'package:absenpraujk/service/db.dart';
import 'package:absenpraujk/service/geo_service.dart';
import 'package:absenpraujk/utils/toast.dart';
import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  Dbhelper dbhelper = Dbhelper();
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) async {
      if (event is DashboardInitialData) {
        emit(DashboardLoading());
        try {
          String currentAddress = "Unknown";
          String currentLatLong = "Unknown";
          double currentLat = 0;
          double currentLong = 0;
          LatLng position = await determineUserLocation();
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            currentAddress =
                "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}, ${place.country}, ${place.isoCountryCode}";
            currentLatLong = "${position.latitude}, ${position.longitude}";
            currentLat = position.latitude;
            currentLong = position.longitude;
          }
          UserModel user = await dbhelper.getUser();
          emit(
            DashboardLoaded(
              user: user,
              currentAddress: currentAddress,
              currentLatLong: currentLatLong,
              currentLat: currentLat,
              currentLong: currentLong,
            ),
          );
        } on Exception catch (e) {
          emit(DashboardFailed());
          showToast(e.toString(), success: false);
        }
      }
    });
  }
}
