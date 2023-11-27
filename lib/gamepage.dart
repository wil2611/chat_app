import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game_features/battle.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Battle game;
  var data = 0;
  bool isTurnOver = true;
  @override
  void initState() {
    super.initState();
    var rng = Random();
    var player1 = rng.nextInt(4) + 1;
    var player2 = rng.nextInt(4) + 1;
    game = Battle(player1, player2, onTurnOver: (bool value) {
      setState(() {
        isTurnOver = value;
        debugPrint("tappable to $value");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double max = screenSize.height / 2 - 104.0;
    double alto = max - ((max * 33 / 70 - 10) * 3 - max);
    double ancho = alto * 33 / 70;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Fight Warriors!"),
          centerTitle: true,
          backgroundColor: const Color(0xFF0F0417)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  data = 4;
                  //game.playerAction(                      data); // Llama a la función playerAction en tu juego
                });
              },
              child: GameWidget(game: game),
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: isTurnOver // Añade esta línea
                            ? () {
                                setState(() {
                                  debugPrint("state changed to Piedra(1)");
                                  data = 1;
                                  game.playerAction(data);
                                  isTurnOver = false; // Añade esta línea
                                });
                              }
                            : null, // Añade esta línea
                        icon: Image.asset(
                          'assets/images/RockCard.png',
                          width: ancho,
                          height: alto,
                        ),
                        tooltip: 'Piedra',
                      ),
                      IconButton(
                        onPressed: isTurnOver // Modifica esta línea
                            ? () {
                                setState(() {
                                  debugPrint("state changed to Papel(2)");
                                  data = 2;
                                  game.playerAction(data);
                                  isTurnOver = false; // Añade esta línea
                                });
                              }
                            : null, // Añade esta línea
                        icon: Image.asset(
                          'assets/images/PaperCard.png',
                          width: ancho,
                          height: alto,
                        ),
                        tooltip: 'Papel',
                      ),
                      IconButton(
                        onPressed: isTurnOver // Modifica esta línea
                            ? () {
                                setState(() {
                                  debugPrint("state changed to Tijera(3)");
                                  data = 3;
                                  game.playerAction(data);
                                  isTurnOver = false; // Añade esta línea
                                });
                              }
                            : null, // Añade esta línea
                        icon: Image.asset(
                          'assets/images/ScissorCard.png',
                          width: ancho,
                          height: alto,
                        ),
                        tooltip: 'Tijera',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              )),
        ],
      ),
    );
  }
}
