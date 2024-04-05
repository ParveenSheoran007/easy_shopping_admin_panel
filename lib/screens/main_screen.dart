import 'package:easy_shopping_admin_panel/utils/constant.dart';
import 'package:easy_shopping_admin_panel/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Admin Panel"),
      ),
      drawer: DrawerWidget(),
    );
  }
}
