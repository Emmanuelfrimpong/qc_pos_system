import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/hive_services/hive_services.dart';
import 'data_state.dart';
import '../core/constants/enums.dart';
import '../repositories/mongodb_api.dart';

final configurationsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final company = await MongodbAPI.getCompanyInfo();
  final users = await MongodbAPI.getUsers();
  var loginInfo = HiveApi.getUserLoginInfo();
  if (loginInfo != null && loginInfo.isNotEmpty) {
    var currentUser = users.firstWhere(
      (element) => element.id == loginInfo,
      orElse: () => UserModel(),
    );
    ref.read(currentUserProvider.notifier).state = currentUser;
  }
  ref.read(companyProvider.notifier).setCompanyInfo(company!);
  ref.read(usersProvider.notifier).setUsers(users);
  return {
    'company': company,
    'admin': users.where((element) => element.role == 'admin').toList(),
  };
});

final companySetupIndex = StateProvider<int>((ref) => 0);

//? add provider for auth page index stack
final authPageIndex = StateProvider<int>((ref) => 0);

//? add side bar size state provider
final sideBarSizeProvider =
    StateNotifierProvider<SideBarSize, double>((ref) => SideBarSize());

class SideBarSize extends StateNotifier<double> {
  SideBarSize() : super(60);
  //set company info
  void setSideBarSize() {
    if (state == 60) {
      state = 210;
    } else {
      state = 60;
    }
  }
}

//? add provider for h HomePageItems
final homePageItemsProvider =
    StateNotifierProvider<HomePageItemsProvider, HomePageItemsList>((ref) {
  return HomePageItemsProvider();
});

class HomePageItemsProvider extends StateNotifier<HomePageItemsList> {
  HomePageItemsProvider() : super(HomePageItemsList.home);
  //set new item
  void setItem(HomePageItemsList item) {
    state = item;
  }
}
