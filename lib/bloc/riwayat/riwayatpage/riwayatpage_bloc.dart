import 'package:absenpraujk/model/AbsenModel.dart';
import 'package:absenpraujk/service/db.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'riwayatpage_event.dart';
part 'riwayatpage_state.dart';

class RiwayatpageBloc extends Bloc<RiwayatpageEvent, RiwayatpageState> {
  Dbhelper dbhelper = Dbhelper();
  RiwayatpageBloc() : super(RiwayatpageInitial()) {
    on<RiwayatpageEvent>((event, emit) async {
      if (event is RiwayatpageInitialEvent) {
        emit(RiwayatpageLoading());
        List<AbsenModel> listAbsen = await dbhelper.getRiwayat();
        emit(RiwayatpageLoaded(listAbsen: listAbsen));
      } else if (event is RiwayatFilter) {
        emit(RiwayatpageLoading());
        List<AbsenModel> listAbsen = await dbhelper.getRiwayatbyFilter(
          filterDate: event.filter,
        );
        emit(RiwayatpageLoaded(listAbsen: listAbsen));
      }
    });
  }
}
