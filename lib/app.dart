import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'routes/app_routes.dart';

class ComfyAIApp extends StatelessWidget {
  const ComfyAIApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      );
}