import 'dart:math';

import 'package:belotable/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  /// The title displayed in the application bar.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('app_bar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Transform.rotate(
              key: const Key('app_bar_icon'),
              angle: -15 * pi / 180,
              child: Assets.icon.image(width: 32, height: 32)
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              key: const Key('app_bar_title'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue !',
              style: Theme.of(context).textTheme.headlineMedium,
              key: const Key('home_body_title')
            ),
          ],
        ),
      ),
    );
  }
}
