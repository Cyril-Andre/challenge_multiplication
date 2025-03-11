
import 'package:challenge_multiplication/common/services/router.dart';
import 'package:challenge_multiplication/theme/theme.dart';
import 'package:flutter/material.dart';

class ChallengeMultiplicationApp extends StatelessWidget {
  const ChallengeMultiplicationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(    
      title: 'Challenge Multiplication',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,      
      routerConfig: router,
    );
  }
}