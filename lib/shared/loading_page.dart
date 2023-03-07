import 'package:flutter/material.dart';
import 'package:my_crumbl/shared/colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CrumblColors.secondary,
      child: const Center(
        child: CircularProgressIndicator(
          color: CrumblColors.primary,
        ),
      ),
    );
  }
}
