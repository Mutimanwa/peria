import 'package:flutter/material.dart';
import 'package:perla_app/core/constants/app_assets.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
       body: SafeArea(
        child: Column(
          children: [
            // logo
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                vertical: 100
              ),
              child: Image.asset(
                AppAssets.logo,
              ),
              
            ),
            // Frame
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset(AppAssets.onbaording_1),
           ),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              children: [
                Text("Welcome To Peria" ),
                Text("Peria helps you understand your body with calm, personalized guidance."),
              ],
            ),
           )
           
          ],
        )),
    );
  }
}