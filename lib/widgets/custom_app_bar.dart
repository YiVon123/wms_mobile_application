import 'package:flutter/material.dart';
import 'package:wms_mobile_application/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int pageIndex;

  const CustomAppBar({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: pageIndex == 2 ? Colors.transparent : AppColors.white,
      elevation: 0,
      actions: [
        if (pageIndex != 2)
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.darkBlue),
            onPressed: () {},
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
