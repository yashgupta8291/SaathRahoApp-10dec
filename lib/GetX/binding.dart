import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:maan/GetX/TokenController.dart';
import 'package:maan/GetX/pincodeController.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<PincodeController>(PincodeController(), permanent: true);
    Get.put<TokenController>(TokenController(), permanent: true);
  }
}
