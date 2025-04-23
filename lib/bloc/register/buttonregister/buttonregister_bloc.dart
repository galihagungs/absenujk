import 'package:absenpraujk/model/UserModel.dart';
import 'package:absenpraujk/service/db.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'buttonregister_event.dart';
part 'buttonregister_state.dart';

class ButtonregisterBloc
    extends Bloc<ButtonregisterEvent, ButtonregisterState> {
  Dbhelper dbhelper = Dbhelper();
  ButtonregisterBloc() : super(ButtonregisterInitial()) {
    on<ButtonregisterEvent>((event, emit) async {
      if (event is ButtonregisterHit) {
        emit(ButtonregisterLoading());
        UserModel userModel = UserModel(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        try {
          String message = await dbhelper.insertUser(data: userModel.toJson());
          emit(ButtonregisterSuccess(message));
        } catch (e) {
          emit(ButtonregisterError(e.toString()));
        }
      }
    });
  }
}
