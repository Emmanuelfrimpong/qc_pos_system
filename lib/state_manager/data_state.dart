import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qc_pos_system/core/constants/enums.dart';
import '../models/company_model.dart';
import '../models/user_model.dart';
import '../repositories/mongodb_api.dart';

final companyProvider =
    StateNotifierProvider<CompanyProvider, CompanyInfoModel>((ref) {
  return CompanyProvider();
});

class CompanyProvider extends StateNotifier<CompanyInfoModel> {
  CompanyProvider() : super(CompanyInfoModel()) {
    getCompanyInfo();
  }
  //set company info
  void setCompanyInfo(CompanyInfoModel company) {
    state = company;
  }

//? get company info from database
  getCompanyInfo() async {
    final company = await MongodbAPI.getCompanyInfo();
    state = company!;
  }

  //? save company info to database an update state
  Future<void> saveCompanyInfo(CompanyInfoModel company) async {
    await MongodbAPI.saveCompanyInfo(company);
    await getCompanyInfo();
  }
}

final usersProvider = StateNotifierProvider<UsersProvider, List<UserModel>>(
    (ref) => UsersProvider());

class UsersProvider extends StateNotifier<List<UserModel>> {
  UsersProvider() : super([]) {
    getUsers();
  }
//? get users from database
  getUsers() async {
    final users = await MongodbAPI.getUsers();
    state = users;
  }

  //? save users to database an update state
  Future<void> saveUser(UserModel users) async {
    await MongodbAPI.saveUser(users.toMap());
    await getUsers();
  }

  Future<String> resetAdminPassword(
      {required String adminId,
      required String question1,
      required String question2,
      required String answer1,
      required String answer2,
      required String password,
      required CompanyInfoModel? company}) async {
    if (company != null && company.companyName != null) {
      //check if secret questions and answers are correct
      if (company.passwordReset!['question1'] == question1 &&
          company.passwordReset!['question2'] == question2 &&
          company.passwordReset!['answer1'].toString().toLowerCase() ==
              answer1.toLowerCase() &&
          company.passwordReset!['answer2'].toString().toLowerCase() ==
              answer2.toLowerCase()) {
        //check if admin id is correct
        final admin = state.firstWhere((element) => element.id == adminId,
            orElse: () => UserModel());
        if (admin.id != null) {
          //update admin password
          admin.password = password;
          await MongodbAPI.saveUser(admin.toMap());
          await getUsers();
          return 'Password reset successfully';
        } else {
          return 'Admin id is incorrect';
        }
      } else {
        return 'Secret questions and answers are incorrect';
      }
    } else {
      return 'Company info is not set';
    }
  }

  void setUsers(List<UserModel> admin) {
    state = admin;
  }

  UserModel login(String s, String t) {
    return state.firstWhere(
        (element) => element.id == s && element.password == t,
        orElse: () => UserModel());
  }

  void updateUserStatus({required String id, required String status}) async {
    final user = state.firstWhere((element) => element.id == id,
        orElse: () => UserModel());
    if (user.id != null) {
      user.status = status;
      await MongodbAPI.saveUser(user.toMap());
      await getUsers();
    }
  }

  void resetPassword({required String id}) async {
    final user = state.firstWhere((element) => element.id == id,
        orElse: () => UserModel());
    if (user.id != null) {
      user.password = '123456';
      await MongodbAPI.saveUser(user.toMap());
      await getUsers();
    }
  }
}

//? add current user provider
final currentUserProvider = StateProvider<UserModel>((ref) => UserModel());

//add Future provider of users accept current user
final usersFutureProvider = FutureProvider<List<UserModel>>((ref) async {
  var currentUser = ref.watch(currentUserProvider);
  final users = await MongodbAPI.getUsers();
  return users
      .where((element) =>
          element.id != currentUser.id &&
          element.status != UserStatus.deleted.toString())
      .toList();
});
