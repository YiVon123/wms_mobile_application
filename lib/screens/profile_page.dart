import 'package:flutter/material.dart';
import 'package:wms_mobile_application/constants/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white, AppColors.lightBlue],
        ),
      ),
      child: Center(
        child: Text(
          'User Profile Page',
          style: TextStyle(fontSize: 24, color: AppColors.darkBlue),
        ),
      ),
    );
  }
}
