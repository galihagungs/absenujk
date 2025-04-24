import 'package:absenpraujk/service/db.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'buttonlogin_event.dart';
part 'buttonlogin_state.dart';

class ButtonloginBloc extends Bloc<ButtonloginEvent, ButtonloginState> {
  Dbhelper dbhelper = Dbhelper();
  ButtonloginBloc() : super(ButtonloginInitial()) {
    on<ButtonloginEvent>((event, emit) async {
      if (event is ButtonloginHit) {
        emit(ButtonloginLoading());
        try {
          String message = await dbhelper.loginUser(
            email: event.email,
            password: event.password,
          );
          if (message == "Login Berhasil") {
            emit(ButtonloginSuccess(message));
          } else {
            emit(ButtonloginFailed("Username atau password salah"));
          }
        } catch (e) {
          emit(ButtonloginFailed("Username atau password salah"));
        }
      }
    });
  }
}
