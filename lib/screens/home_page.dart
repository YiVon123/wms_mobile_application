import 'package:flutter/material.dart';
import 'package:wms_mobile_application/constants/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 24, color: Colors.blue[900]),
        ),
      ),
    );
  }
}
