import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/models/user_model.dart';
import 'package:intellimeal/services/user_services.dart';

class UserController extends GetxController {
  String token = GetStorage().read('token') ?? '';
  String userId = GetStorage().read('userId') ?? '';

  final user = Rx<User>(User());
  final dailyPlanList = Rx<List<DailyPlan>>([]);

  

  var selectedDailyPlan = Rx<DailyPlan?>(null);

  void getUser() {
    if (userId.isEmpty) return;
    UserService().getUser(userId, token).then((value) {
      user.value = value;
    });
  }

  void getDailyPlan() {
    if (userId.isEmpty) return;
    UserService().getDailyPlan(userId, token).then((value) {
      dailyPlanList.value = value.dailyPlans ?? [];
    });
  }

  void setSelectedDailyPlan(int index) {
    selectedDailyPlan.value = dailyPlanList.value[index];
  }
}
