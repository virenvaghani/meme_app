import 'package:flutter/material.dart';
import 'package:meme_app/screens/meme_home_page.dart';

void main() {
  runApp(const MemeApp());
}

class MemeApp extends StatelessWidget {
  const MemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meme App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const MemeHomePage(),
    );
  }
}
