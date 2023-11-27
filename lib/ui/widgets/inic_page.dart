import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../gamepage.dart';

class MyHomePagea extends StatelessWidget {
  // This widget is the root of your application.
  const MyHomePagea({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warriors of fate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Estás listo para la batalla?',
            ),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              onPressed: () {
                WidgetsFlutterBinding.ensureInitialized();
                Flame.device.fullScreen();
                Flame.device.setPortraitUpOnly();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
              tooltip: 'Increment',
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
