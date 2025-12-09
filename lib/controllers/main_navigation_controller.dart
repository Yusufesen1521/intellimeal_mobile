import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  // Current selected index - default to Home (index 2)
  final RxInt currentIndex = 2.obs;

  // Page names for reference
  static const List<String> pageNames = [
    'Statistics',
    'Calender',
    'Home',
    'Profile',
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  String get currentPageName => pageNames[currentIndex.value];
}
