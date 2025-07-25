import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:wms_mobile_application/constants/colors.dart';

class CurvedNavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const CurvedNavBar({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 60,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: pageIndex == 2 ? Colors.transparent : Colors.white,
      color: pageIndex == 2 ? AppColors.blue : AppColors.lightBlue!,
      animationDuration: const Duration(milliseconds: 300),
      index: pageIndex,
      items: [
        Icon(
          Icons.home,
          size: 30,
          color: pageIndex == 2 ? AppColors.white : AppColors.darkBlue,
        ),
        Icon(
          Icons.schedule,
          size: 30,
          color: pageIndex == 2 ? AppColors.white : AppColors.darkBlue,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: pageIndex == 2 ? AppColors.white : AppColors.darkBlue,
        ),
      ],
      onTap: onTap,
    );
  }
}
