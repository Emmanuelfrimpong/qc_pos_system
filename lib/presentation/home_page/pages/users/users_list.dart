import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qc_pos_system/models/user_model.dart';
import '../../../../core/constants/enums.dart';
import '../../../../state_manager/init_state.dart';
import '../../../../utils/styles.dart';
import 'package:responsive_table/responsive_table.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/smart_dialog.dart';
import '../../../../state_manager/data_state.dart';
import '../../../../utils/colors.dart';

class UsersListPage extends ConsumerStatefulWidget {
  const UsersListPage({super.key});

  @override
  ConsumerState<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends ConsumerState<UsersListPage> {
  final List<int> _perPages = [10, 20, 50, 100];
  int? _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _source = [];
  bool _isLoading = true;
  bool isSearching = false;
  _resetData({start = 0, List<Map<String, dynamic>>? data}) async {
    setState(() => _isLoading = true);
    var expandedLen = data!.length - start < _currentPerPage!
        ? data.length - start
        : _currentPerPage;
    _source.clear();
    _source = data.getRange(start, start + expandedLen).toList();
    setState(() => _isLoading = false);
  }

  _mockPullData() {
    var dataLength = ref.watch(filteredUsersToMapProvider).length;
    setState(() => _isLoading = true);
    _source = dataLength >= _currentPerPage!
        ? ref
            .watch(filteredUsersToMapProvider)
            .getRange(0, _currentPerPage!)
            .toList()
        : ref.watch(filteredUsersToMapProvider).toList();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    //check if widget is build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mockPullData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(currentUserProvider);
    var size = MediaQuery.of(context).size;
    int total = ref.watch(filteredUsersToMapProvider).length;
    ref.listen(filteredUsersToMapProvider, ((old, current) {
      _resetData(data: current);
    }));
    return ResponsiveDatatable(
      autoHeight: false,
      title: Text(
        "Users",
        style: getCustomTextStyle(context,
            fontWeight: FontWeight.bold, fontSize: 32),
      ),
      onTabRow: (data) {},
      actions: [
        const Spacer(),
        //create search bar if isSearching is true
        if (isSearching || size.width > 900)
          SizedBox(
            width: size.width > 900 ? 700 : 430,
            child: CustomTextFields(
              hintText: "Search user",
              onChanged: (value) {
                ref.read(queryStringProvider.notifier).state = value;
                _resetData(data: ref.watch(filteredUsersToMapProvider));
              },
            ),
          ),
        if (size.width < 900)
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                color: primaryColor,
              )),
        const SizedBox(
          width: 10,
        ),
        CustomButton(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          onPressed: () => {
            ref
                .read(homePageItemsProvider.notifier)
                .setItem(HomePageItemsList.newUser)
          },
          icon: Icons.add,
          text: "New User",
        ),
        const SizedBox(
          width: 10,
        ),
      ],
      headerTextStyle: getCustomTextStyle(context,
          fontSize: 16, fontWeight: FontWeight.w600),
      reponseScreenSizes: const [
        ScreenSize.xs,
        ScreenSize.sm,
        //ScreenSize.md,
        // ScreenSize.lg
      ],
      source: _source,
      isLoading: _isLoading,
      selecteds: [],
      expanded: [false],
      footers: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text("Rows per page:"),
        ),
        if (_perPages.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<int>(
              value: _currentPerPage,
              items: _perPages
                  .map((e) => DropdownMenuItem<int>(
                        value: e,
                        child: Text("$e"),
                      ))
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _currentPerPage = value;
                  _currentPage = 1;
                  _resetData(data: ref.watch(filteredUsersToMapProvider));
                });
              },
              isExpanded: false,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
              "$_currentPage - ${_currentPerPage! + _currentPage - 1} of $total"),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: _currentPage == 1
              ? null
              : () {
                  var _nextSet = _currentPage - _currentPerPage!;
                  setState(() {
                    _currentPage = _nextSet > 1 ? _nextSet : 1;
                    _resetData(
                        start: _currentPage - 1,
                        data: ref.watch(filteredUsersToMapProvider));
                  });
                },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _currentPage + _currentPerPage! - 1 >= total
              ? null
              : () {
                  var nextSet = _currentPage + _currentPerPage!;

                  setState(() {
                    _currentPage =
                        nextSet < total ? nextSet : total - _currentPerPage!;
                    _resetData(
                        start: nextSet - 1,
                        data: ref.watch(filteredUsersToMapProvider));
                  });
                },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        )
      ],
      headers: [
        DatatableHeader(
          text: "Image",
          value: "image",
          show: true,
          sortable: false,
          textAlign: TextAlign.center,
          sourceBuilder: (value, row) {
            if (value != null) {
              return Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(File(value)), fit: BoxFit.contain)),
              );
            } else {
              return Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/user.png'),
                        fit: BoxFit.contain)),
              );
            }
          },
        ),
        DatatableHeader(
            text: "ID",
            value: "id",
            show: true,
            sortable: true,
            textAlign: TextAlign.center),
        DatatableHeader(
            text: "Name",
            value: "fullName",
            show: true,
            sortable: true,
            textAlign: TextAlign.start),
        DatatableHeader(
            text: "Phone",
            value: "telephone",
            show: true,
            sortable: true,
            textAlign: TextAlign.center),
        DatatableHeader(
            text: "Role",
            value: "role",
            show: true,
            sortable: true,
            textAlign: TextAlign.center),
        DatatableHeader(
            text: "Status",
            value: "status",
            show: true,
            sortable: true,
            textAlign: TextAlign.center,
            sourceBuilder: (value, row) {
              return Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: value == "active".toLowerCase()
                        ? Colors.green
                        : Colors.redAccent),
              );
            }),
        DatatableHeader(
            text: "Last Login",
            value: "lastLogin",
            show: true,
            sortable: true,
            textAlign: TextAlign.center,
            sourceBuilder: (value, row) {
              return Text(
                value ?? "Never",
                textAlign: TextAlign.center,
              );
            }),
        DatatableHeader(
            text: "Action",
            value: "id",
            show: true,
            sortable: false,
            textAlign: TextAlign.center,
            sourceBuilder: (value, row) {
              var userState = row['status'];
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentUser.id != value)
                    Tooltip(
                      message: 'Edit User',
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: primaryColor),
                        onPressed: () {
                          editUser(row);
                        },
                      ),
                    ),
                  const SizedBox(width: 10),
                  //check if the user is the current user
                  if (currentUser.role != null &&
                      currentUser.role!.toLowerCase() == "admin" &&
                      currentUser.id != value)
                    PopupMenuButton(
                        onSelected: (status) => changeUserStatus(status, value),
                        icon: const Icon(
                          Icons.more_vert,
                          color: primaryColor,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: userState == "active"
                                  ? UserStatus.inactive
                                  : UserStatus.active,
                              child: Row(
                                children: [
                                  Icon(
                                      userState == "active"
                                          ? Icons.cancel
                                          : Icons.check_circle,
                                      color: userState == "active"
                                          ? Colors.redAccent
                                          : Colors.green),
                                  const SizedBox(width: 5),
                                  Text(
                                    userState == "active"
                                        ? "Deactivate"
                                        : "Activate",
                                    style: GoogleFonts.openSans(
                                        color: userState == "active"
                                            ? Colors.redAccent
                                            : Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: UserStatus.reset,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Reset Password",
                                    style: GoogleFonts.openSans(
                                        color: primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            //add delete
                            PopupMenuItem(
                              value: UserStatus.deleted,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Delete",
                                    style: GoogleFonts.openSans(
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        }),
                  const SizedBox(
                    width: 25,
                  )
                ],
              );
            }),
      ],
    );
  }

  changeUserStatus(UserStatus status, String id) {
    switch (status) {
      case UserStatus.active:
        CustomDialog.showInfo(
          title: "Activate User",
          message: 'Are you sure you want to activate this user?',
          onConfirmText: 'Activate',
          onConfirm: () {
            updateState(UserStatus.active, id);
          },
        );
        break;
      case UserStatus.inactive:
        CustomDialog.showInfo(
          title: "Deactivate User",
          message: 'Are you sure you want to deactivate this user?',
          onConfirmText: 'Deactivate',
          onConfirm: () {
            updateState(UserStatus.inactive, id);
          },
        );
        break;
      case UserStatus.reset:
        CustomDialog.showInfo(
          title: "Reset Password",
          message: 'Are you sure you want to reset this user password?',
          onConfirmText: 'Reset',
          onConfirm: () {
            updateState(UserStatus.reset, id);
          },
        );
        break;
      case UserStatus.deleted:
        CustomDialog.showInfo(
          title: "Delete User",
          message: 'Are you sure you want to delete this user? \n'
              'This action cannot be undone',
          onConfirmText: 'Delete',
          onConfirm: () {
            updateState(UserStatus.deleted, id);
          },
        );
        break;
    }
  }

  updateState(UserStatus status, String id) {
    CustomDialog.dismiss();
    if (status == UserStatus.active) {
      CustomDialog.showLoading(message: 'Activating user... Please wait');
    } else if (status == UserStatus.inactive) {
      CustomDialog.showLoading(message: 'Deactivating user... Please wait');
    } else if (status == UserStatus.reset) {
      CustomDialog.showLoading(
          message: 'Resetting user password... Please wait');
    } else if (status == UserStatus.deleted) {
      CustomDialog.showLoading(message: 'Deleting user... Please wait');
    }
    if (status != UserStatus.reset) {
      ref
          .read(usersProvider.notifier)
          .updateUserStatus(id: id, status: status.name.toLowerCase());
    } else {
      ref.read(usersProvider.notifier).resetPassword(id: id);
    }
    // var users = ref.watch(usersProvider);
    // ref.read(filteredUsersToMapProvider.notifier).state =
    //     users.map((e) => e.toMap()).toList();

    // ref.invalidate(filteredUsersToMapProvider);
    CustomDialog.dismiss();
    if (status == UserStatus.reset) {
      CustomDialog.showToast(message: 'User password reset successfully');
    } else if (status == UserStatus.deleted) {
      CustomDialog.showToast(message: 'User deleted successfully');
    } else if (status == UserStatus.inactive) {
      CustomDialog.showToast(message: 'User deactivated successfully');
    } else if (status == UserStatus.active) {
      CustomDialog.showToast(message: 'User activated successfully');
    }
  }

  void editUser(Map<String?, dynamic> row) {
    // conver the row from <String?, dynamic> to <String, dynamic>
    var newRow = row.map((key, value) => MapEntry(key!, value));
    UserModel selectedUser = UserModel.fromMap(newRow);
    ref.read(selectedUserProvider.notifier).state = selectedUser;
    ref
        .read(homePageItemsProvider.notifier)
        .setItem(HomePageItemsList.editUser);
  }
}
