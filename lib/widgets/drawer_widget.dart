import 'package:easy_shopping_admin_panel/screens/all_orders_screen.dart';
import 'package:easy_shopping_admin_panel/screens/all_products_screen.dart';
import 'package:easy_shopping_admin_panel/screens/all_users_screen.dart';
import 'package:easy_shopping_admin_panel/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constant.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User? user = FirebaseAuth.instance.currentUser;

  String userName = 'User';
  String firstLetter = 'U';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        )),
        width: Get.width - 80.0,
        backgroundColor: AppConstant.appScendoryColor,
        child: Wrap(
          runSpacing: 10,
          children: [
            user != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        userName.toString(),
                        style: const TextStyle(color: AppConstant.appTextColor),
                      ),
                      subtitle: Text(
                        AppConstant.appVersion,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      leading: CircleAvatar(
                        radius: 22.0,
                        backgroundColor: AppConstant.appMainColor,
                        child: Text(
                          firstLetter,
                          style: const TextStyle(color: AppConstant.appTextColor),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: const Text(
                        "Parveen",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      subtitle: Text(
                        AppConstant.appVersion,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      leading: const CircleAvatar(
                        radius: 22.0,
                        backgroundColor: AppConstant.appMainColor,
                        child: Text(
                          "P",
                          style: TextStyle(color: AppConstant.appTextColor),
                        ),
                      ),
                    ),
                  ),
            const Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.offAll(() => const MainScreen());
                },
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.to(() => const AllUsersScreen());
                },
                title: const Text(
                  'Users',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.to(() => const AllOrdersScreen());
                },
                title: const Text(
                  'Orders',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => const AllProductsScreen());
                },
                title: const Text(
                  'Products',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.production_quantity_limits,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                onTap: () async {
                  Get.back();
                  EasyLoading.show(status: "Please wait");

                  await sendMessage();
                  EasyLoading.dismiss();
                },
                title: const Text(
                  'Categories',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.category,
                  color: Colors.white,
                ),
              ),
            ),
            if (user != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  onTap: () {

                  },
                  title: const Text(
                    'Customer Reviews',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.reviews_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {

                },
                title: const Text(
                  'Contact',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () async {

                },
                title: Text(
                  user != null ? 'Logout' : 'Login',
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  user != null ? Icons.logout : Icons.login,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),

      ),
    );
  }

  static Future<void> sendMessage() async {
    final phoneNumber = AppConstant.whatsAppNumber;
    final message =
        "Hello *${AppConstant.appMainName}*";

    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
