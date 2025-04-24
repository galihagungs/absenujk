import 'package:absenpraujk/model/UserModel.dart';
import 'package:absenpraujk/service/db.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profilepage_event.dart';
part 'profilepage_state.dart';

class ProfilepageBloc extends Bloc<ProfilepageEvent, ProfilepageState> {
  Dbhelper dbhelper = Dbhelper();
  ProfilepageBloc() : super(ProfilepageInitial()) {
    on<ProfilepageEvent>((event, emit) async {
      if (event is ProfilepageInitialEvent) {
        emit(ProfilepageLoading());
        UserModel user = await dbhelper.getUser();
        emit(ProfilepageLoaded(user: user));
      } else if (event is ProfilepageEditEvent) {
        emit(ProfilepageLoading());
        emit(ProfilepageEdit(user: event.user));
      } else if (event is ProfilepageSaveEvent) {
        emit(ProfilepageLoading());
        try {
          // Prepare data for updating the user profile
          Map<String, dynamic> updatedData = {
            'name': event.name,
            'email': event.email,
          };

          // Call the updateUserProfile function
          bool status = await dbhelper.updateUserProfile(data: updatedData);
          if (status) {
            UserModel user = await dbhelper.getUser();
            emit(ProfilepageLoaded(user: user));
          }

          // Fetch the updated user data
        } on Exception catch (e) {}
      }
    });
  }
}
