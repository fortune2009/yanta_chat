import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yanta/commons/assets.dart';
import 'package:yanta/commons/utils.dart';
import 'package:yanta/view/home_page.dart';

import '../commons/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    const duration = Duration(seconds: 3);
    return Timer(duration, () {
      route();
    });
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: deviceWidth(context),
        height: deviceHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight(context) / 8,
            ),
            Image(
              image: const AssetImage(ImageAssets.logo),
              width: deviceWidth(context) / 1.8,
              height: deviceHeight(context) / 1.8,
            ),
            SizedBox(
              height: deviceHeight(context) / 8,
            ),
            Styles.mediumTextStyle("from", color: AppColors.black),
            // SizedBox(
            //   height: 14,
            // ),
            Image(
              image: const AssetImage(ImageAssets.enyata),
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
