import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intellimeal/models/user_model.dart';

class UserController extends GetxController {
  String token = '';
  User user = User(
    id: '',
    name: '',
    surname: '',
    phoneNumber: '',
    email: '',
    password: '',
    role: '',
    personalInfo: [],
  );

  void setUser(User user) {
    this.user = user;
  }

  void setToken(String token) {
    this.token = token;
  }
}
