import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/salesman_auth_service.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<SalesmanAuthService>(),
        Get.find<AuthStorage>(),
      ),
    );
  }
}
