import 'package:metakinisi/shared/SharedPreferencesProvider.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';

class ProfileService {
  ProfileViewModel getProfile() {
    var profileName = SharedPreferencesProvider.get('profileName');
    if (profileName == null) return null;
    var vm = new ProfileViewModel();
    vm.name = SharedPreferencesProvider.get('profileName');
    vm.street = SharedPreferencesProvider.get('profileStreet');
    vm.area = SharedPreferencesProvider.get('profileArea');

    return vm;
  }

  Future saveProfile(ProfileViewModel vm) async {
    SharedPreferencesProvider.saveString('profileName', vm.name);
    SharedPreferencesProvider.saveString('profileStreet', vm.street);
    SharedPreferencesProvider.saveString('profileArea', vm.area);
  }

  Future deleteProfile() async {
    await SharedPreferencesProvider.remove('profileName');
    await SharedPreferencesProvider.remove('profileStreet');
    await SharedPreferencesProvider.remove('profileArea');
  }
}
