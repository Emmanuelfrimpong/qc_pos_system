import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/smart_dialog.dart';
import '../../../repositories/hive_services/hive_services.dart';
import '../../../state_manager/init_state.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

import '../../../core/constants/enums.dart';
import '../../../models/user_model.dart';
import '../../../state_manager/data_state.dart';

class SideBar extends ConsumerWidget {
  SideBar({super.key});
  final GlobalKey _buttonKey = GlobalKey();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(currentUserProvider);
    return SizedBox(
      width: ref.watch(sideBarSizeProvider),
      key: _buttonKey,
      child: Column(children: [
        MenuItem(
          icon: Icons.dehaze_outlined,
          onTap: () => ref.read(sideBarSizeProvider.notifier).setSideBarSize(),
          isSelected: false,
        ),
        const SizedBox(height: 10),
        Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
          MenuItem(
            icon: fluent.FluentIcons.view_dashboard,
            title: 'Dashboard',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.home);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.home,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.group,
            title: 'Users',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.user);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.user,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.all_currency,
            title: 'Sales',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.sales);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.sales,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.product_list,
            title: 'Products',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.products);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.products,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.return_to_session,
            title: 'Returns',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.damages);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.damages,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.b_i_dashboard,
            title: 'Reports',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.report);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.report,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.delivery_truck,
            title: 'Suppliers',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.suppliers);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.suppliers,
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: fluent.FluentIcons.transition,
            title: 'Customers',
            onTap: () {
              ref
                  .read(homePageItemsProvider.notifier)
                  .setItem(HomePageItemsList.customers);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.customers,
          ),
        ]))),
        const SizedBox(height: 10),
        const Divider(
          color: Colors.black12,
          thickness: 2,
        ),
        const SizedBox(height: 10),
        if (user.id != null)
          MenuItem(
            icon: fluent.FluentIcons.user_gauge,
            title: 'Profile',
            hasSubItems: true,
            onTap: () {
              _showContextMenu(context, ref);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.profile,
            child: ClipOval(
                child: user.image != null
                    ? Image.file(File(user.image!))
                    : const Icon(
                        fluent.FluentIcons.user_remove,
                        color: Colors.black45,
                        size: 28,
                      )),
          )
        else
          MenuItem(
            icon: fluent.FluentIcons.user_gauge,
            title: 'Profile',
            hasSubItems: true,
            onTap: () {
              _showContextMenu(context, ref);
            },
            isSelected:
                ref.watch(homePageItemsProvider) == HomePageItemsList.profile,
            child: const fluent.ProgressRing(
              activeColor: primaryColor,
            ),
          ),
        const SizedBox(height: 10),
        MenuItem(
          icon: fluent.FluentIcons.settings,
          title: 'Settings',
          onTap: () {
            ref
                .read(homePageItemsProvider.notifier)
                .setItem(HomePageItemsList.settings);
          },
          isSelected:
              ref.watch(homePageItemsProvider) == HomePageItemsList.settings,
        ),
      ]),
    );
  }

  void _showContextMenu(BuildContext context, WidgetRef ref) async {
    var user = ref.watch(currentUserProvider);
    final RenderBox renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final result = await showMenu(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        context: context,
        // Show the context menu at the tap location
        position: RelativeRect.fromLTRB(size.width, offset.dy + size.height * 2,
            size.width, offset.dy + size.height),
        items: [
          PopupMenuItem(
            value: 1,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipOval(
                  child: user.image != null
                      ? Image.file(File(user.image!))
                      : const Icon(
                          fluent.FluentIcons.user_remove,
                          color: Colors.black45,
                          size: 28,
                        )),
              title: Text(
                user.fullName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getCustomTextStyle(context,
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.telephone!,
                    style: getCustomTextStyle(context, fontSize: 14),
                  ),
                  Text(
                    user.role!,
                    style: getCustomTextStyle(context, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text('Profile'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('Logout'),
          ),
        ]);
    if (result == 1) {
      ref
          .read(homePageItemsProvider.notifier)
          .setItem(HomePageItemsList.profile);
    } else if (result == 2) {
      CustomDialog.showInfo(
          title: 'User Sign out',
          onConfirmText: 'Sign out',
          onConfirm: () {
            CustomDialog.dismiss();
            CustomDialog.showLoading(message: 'Logging out...');
            HiveApi.removeLoginData();
            ref.read(currentUserProvider.notifier).state = UserModel();
            ref.refresh(configurationsProvider);
            CustomDialog.dismiss();
          },
          message: 'Are you sure you want to sign out?');
    }
  }
}

class MenuItem extends ConsumerStatefulWidget {
  const MenuItem(
      {super.key,
      this.title,
      required this.icon,
      this.onTap,
      this.onHover,
      this.hasSubItems = false,
      this.child,
      this.isSelected = false});
  final String? title;
  final IconData icon;
  final Function()? onTap;
  //add onHover function
  final Function(bool)? onHover;
  final bool? isSelected;
  final bool? hasSubItems;
  final Widget? child;

  @override
  ConsumerState<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends ConsumerState<MenuItem> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    if (ref.watch(sideBarSizeProvider) == 60) {
      return Tooltip(
        message: widget.title ?? '',
        verticalOffset: -13,
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(left: 50),
        child: InkWell(
            onHover: (value) {
              setState(() {
                isHover = value;
              });
              if (widget.onHover != null) {
                widget.onHover!(value);
              }
            },
            onTap: widget.onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isSelected!)
                  Container(
                    color: primaryColor,
                    height: 50,
                    width: 4,
                    margin: const EdgeInsets.only(right: 2),
                  ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: (isHover || widget.isSelected!)
                        ? Colors.black.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                  child: Center(
                      child: widget.child ??
                          Icon(
                            widget.icon,
                            color: Colors.black45,
                            size: 28,
                          )),
                ),
              ],
            )),
      );
    } else {
      return InkWell(
          onHover: (value) {
            setState(() {
              isHover = value;
            });
            if (widget.onHover != null) {
              widget.onHover!(value);
            }
          },
          onTap: widget.onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected!)
                Container(
                  color: primaryColor,
                  height: 50,
                  width: 4,
                  margin: const EdgeInsets.only(right: 2),
                ),
              Container(
                height: 50,
                width: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (isHover || widget.isSelected!)
                      ? Colors.black.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      widget.child ??
                          Icon(widget.icon, color: Colors.black45, size: 28),
                      const SizedBox(width: 10),
                      if (widget.title != null)
                        Text(widget.title!,
                            style: GoogleFonts.openSans(
                                color: Colors.black38,
                                fontSize: 16,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w700)),
                      const Spacer(),
                      if (widget.hasSubItems!)
                        const Icon(Icons.arrow_drop_down,
                            color: Colors.black45, size: 28),
                    ],
                  ),
                ),
              ),
            ],
          ));
    }
  }
}
