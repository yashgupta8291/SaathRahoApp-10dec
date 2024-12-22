import 'package:get/get.dart';
import 'package:maan/ApiServices/ApiServices.dart';

import '../ApiServices/locationApiService.dart';

class PincodeController extends GetxController {

  RxString pincode = ''.obs;
  RxBool isPincodeVerified = false.obs;

  Future<void> verifyPincode(String _pincode) async {
    isPincodeVerified.value =
        await LocationFromPincode().getLocation(pincode: _pincode);
    print(isPincodeVerified.value);
  }
}
