import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

typedef TurnOverCallback = void Function(bool isTurnOver);

class Battle extends FlameGame {
  final TurnOverCallback onTurnOver;
  final int player1character;
  final int player2character;

  Battle(this.player1character, this.player2character,
      {required this.onTurnOver});
  SpriteAnimationComponent player1 = SpriteAnimationComponent();
  SpriteAnimationComponent player2 = SpriteAnimationComponent();
  SpriteComponent background = SpriteComponent();
  TextPaint dialog =
      TextPaint(style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)));
  int player1movement = 0;
  int player2movement = 0;
  int player1CurrentLifes = 3;
  int player2CurrentLifes = 3;
  List<SpriteComponent> player1Hearts = [];
  List<SpriteComponent> player2Hearts = [];
  int movementspeed = 70;
  bool empate = false;

  var texto = "Batalla empezando";
  void removeHeart(int player) async {
    var heartSprite = await loadSprite('Empty_Hearts.png');
    switch (player) {
      case 1:
        double x = player1Hearts[player1CurrentLifes - 1].x;
        double y = player1Hearts[player1CurrentLifes - 1].y;
        remove(player1Hearts[player1CurrentLifes - 1]);
        player1Hearts[player1CurrentLifes - 1] =
            SpriteComponent(sprite: heartSprite, size: Vector2(32, 32));
        player1Hearts[player1CurrentLifes - 1].x = x;
        player1Hearts[player1CurrentLifes - 1].y = y;
        add(player1Hearts[player1CurrentLifes - 1]);
        player1CurrentLifes--;
        break;
      case 2:
        double x = player2Hearts[player2CurrentLifes - 1].x;
        double y = player2Hearts[player2CurrentLifes - 1].y;
        remove(player2Hearts[player2CurrentLifes - 1]);
        player2Hearts[player2CurrentLifes - 1] =
            SpriteComponent(sprite: heartSprite, size: Vector2(32, 32));
        player2Hearts[player2CurrentLifes - 1].x = x;
        player2Hearts[player2CurrentLifes - 1].y = y;
        add(player2Hearts[player2CurrentLifes - 1]);
        player2CurrentLifes--;
        break;
    }
  }

  void changeSprite(int player, int action) async {
    final spriteSize = Vector2(150, 600);
    final spriteSize2 = Vector2(150, 1200);

    var spriteSheetSkeletonIdle = await images.load('SkeletonIdle.png');
    var spriteSheetSkeletonAttack = await images.load('SkeletonAttack.png');
    var spriteSheetSkeletonWalk = await images.load('SkeletonWalk.png');
    var spriteSheetSkeletonTakeHit = await images.load('SkeletonTakeHit.png');
    var spriteSheetSkeletonDeath = await images.load('SkeletonDeath.png');

    var spriteSheetBatIdle = await images.load('BatFlight.png');
    var spriteSheetBatAttack = await images.load('BatAttack.png');
    var spriteSheetBatWalk = await images.load('BatFlight.png');
    var spriteSheetBatTakeHit = await images.load('BatTakeHit.png');
    var spriteSheetBatDeath = await images.load('BatDeath.png');

    var spriteSheetMushIdle = await images.load('MushIdle.png');
    var spriteSheetMushAttack = await images.load('MushAttack.png');
    var spriteSheetMushWalk = await images.load('MushRun.png');
    var spriteSheetMushTakeHit = await images.load('MushTakeHit.png');
    var spriteSheetMushDeath = await images.load('MushDeath.png');

    var spriteSheetGoblinIdle = await images.load('GoblinIdle.png');
    var spriteSheetGoblinAttack = await images.load('GoblinAttack.png');
    var spriteSheetGoblinWalk = await images.load('GoblinRun.png');
    var spriteSheetGoblinTakeHit = await images.load('GoblinTakeHit.png');
    var spriteSheetGoblinDeath = await images.load('GoblinDeath.png');
    double x = 0;
    double y = 0;
    switch (action) {
      case 1:
        switch (player) {
          case 1:
            x = player1.x;
            y = player1.y;
            remove(player1);
            switch (player1character) {
              case 1:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonIdle,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.1, textureSize: spriteSize))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinIdle,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.1, textureSize: spriteSize))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushIdle,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.3, textureSize: spriteSize))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatIdle,
                    SpriteAnimationData.sequenced(
                        amount: 8, stepTime: 0.2, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
            }
            add(player1);
            if (player1movement == 1) {
              updateMovement(1, 2);
              changeSprite(1, 2);
            }
            break;
          case 2:
            x = player2.x;
            y = player2.y;
            remove(player2);
            switch (player2character) {
              case 1:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonIdle,
                    SpriteAnimationData.sequenced(
                      amount: 4,
                      stepTime: 0.1,
                      textureSize: spriteSize,
                    ))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinIdle,
                    SpriteAnimationData.sequenced(
                      amount: 4,
                      stepTime: 0.1,
                      textureSize: spriteSize,
                    ))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushIdle,
                    SpriteAnimationData.sequenced(
                      amount: 4,
                      stepTime: 0.3,
                      textureSize: spriteSize,
                    ))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatIdle,
                    SpriteAnimationData.sequenced(
                      amount: 8,
                      stepTime: 0.3,
                      textureSize: spriteSize2,
                    ))
                  ..x = x
                  ..y = y;
                break;
            }
            player2.flipHorizontally();
            add(player2);
            if (player2movement == 1) {
              updateMovement(2, 2);
              changeSprite(2, 2);
            }
            break;
        }
        break;
      case 2:
        switch (player) {
          case 1:
            x = player1.x;
            y = player1.y;
            remove(player1);
            switch (player1character) {
              case 1:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.1,
                        textureSize: spriteSize2,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.05,
                        textureSize: spriteSize2,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.1,
                        textureSize: spriteSize2,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.1,
                        textureSize: spriteSize2,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
            }
            add(player1);
            await Future.delayed(const Duration(milliseconds: 500));
            changeSprite(2, 4);
            if (player2CurrentLifes > 0) {
              removeHeart(2);
            }
            await Future.delayed(const Duration(milliseconds: 500));
            changeSprite(1, 1);
            await Future.delayed(const Duration(milliseconds: 500));
            player1.flipHorizontally();
            player1.x = player2.x - 30;
            player1.y = player2.y;
            updateMovement(1, 3);
            changeSprite(1, 3);
            await Future.delayed(const Duration(milliseconds: 200));
            changeSprite(2, 1);
            break;
          case 2:
            x = player2.x;
            y = player2.y;
            await Future.delayed(const Duration(seconds: 1));
            remove(player2);
            switch (player2character) {
              case 1:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.05,
                        textureSize: spriteSize2,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatAttack,
                    SpriteAnimationData.sequenced(
                        amount: 8,
                        stepTime: 0.1,
                        textureSize: spriteSize2,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
            }
            player2.flipHorizontally();
            add(player2);
            await Future.delayed(const Duration(milliseconds: 500));
            changeSprite(1, 4);
            if (player1CurrentLifes > 0) {
              removeHeart(1);
            }
            await Future.delayed(const Duration(milliseconds: 500));
            changeSprite(2, 1);
            await Future.delayed(const Duration(milliseconds: 500));
            player2.x = player1.x + 30;
            player2.y = player1.y;
            updateMovement(2, 3);
            changeSprite(2, 3);
            await Future.delayed(const Duration(milliseconds: 200));
            changeSprite(1, 1);
            break;
        }
        break;
      case 3:
        switch (player) {
          case 1:
            x = player1.x;
            y = player1.y;
            remove(player1);
            switch (player1character) {
              case 1:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonWalk,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.1, textureSize: spriteSize))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinWalk,
                    SpriteAnimationData.sequenced(
                        amount: 8, stepTime: 0.1, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushWalk,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.2, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatWalk,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.2, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
            }
            add(player1);
            if (player1movement == 3) {
              player1.flipHorizontally();
            }
            break;
          case 2:
            x = player2.x;
            y = player2.y;
            remove(player2);
            switch (player2character) {
              case 1:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonWalk,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.1, textureSize: spriteSize))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinWalk,
                    SpriteAnimationData.sequenced(
                        amount: 8, stepTime: 0.1, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushWalk,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.2, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatWalk,
                    SpriteAnimationData.sequenced(
                        amount: 4, stepTime: 0.2, textureSize: spriteSize2))
                  ..x = x
                  ..y = y;
                break;
            }
            player2.flipHorizontally();
            add(player2);
            if (player2movement == 3) {
              player2.flipHorizontally();
            }
            break;
        }
        break;
      case 4:
        switch (player) {
          case 1:
            x = player1.x;
            y = player1.y;
            remove(player1);
            switch (player1character) {
              case 1:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
            }
            add(player1);
            break;
          case 2:
            x = player2.x;
            y = player2.y;
            remove(player2);
            switch (player2character) {
              case 1:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player2 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatTakeHit,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
            }
            player2.flipHorizontally();
            add(player2);
            break;
        }
        break;
      case 5:
        switch (player) {
          case 1:
            x = player1.x;
            y = player1.y;
            remove(player1);
            switch (player1character) {
              case 1:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetSkeletonDeath,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 2:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetGoblinDeath,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 3:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetMushDeath,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
              case 4:
                player1 = SpriteAnimationComponent.fromFrameData(
                    spriteSheetBatDeath,
                    SpriteAnimationData.sequenced(
                        amount: 4,
                        stepTime: 0.1,
                        textureSize: spriteSize,
                        loop: false))
                  ..x = x
                  ..y = y;
                break;
            }
            add(player1);
            break;
          case 2:
            x = player2.x;
            y = player2.y;
            remove(player2);
            player2 = SpriteAnimationComponent.fromFrameData(
                spriteSheetGoblinDeath,
                SpriteAnimationData.sequenced(
                    amount: 4,
                    stepTime: 0.2,
                    textureSize: spriteSize,
                    loop: false))
              ..x = x
              ..y = y;
            player2.flipHorizontally();
            add(player2);
            break;
        }
        break;
    }
  }

  void playerAction(int action) async {
    // Genera un número aleatorio para la acción del oponente
    var rng = Random();
    var opponentAction =
        rng.nextInt(3) + 1; // 1 = Piedra, 2 = Papel, 3 = Tijera

    // final screenHeight = canvasSize[0];
    // final screenwidth = canvasSize[1];
    // Compara la acción del jugador con la del oponente
    if ((action == 1 && opponentAction == 3) ||
        (action == 2 && opponentAction == 1) ||
        (action == 3 && opponentAction == 2)) {
      // El jugador gana
      switch (action) {
        case 1:
          texto = 'El jugador eligió Piedra y ganó';
          break;
        case 2:
          texto = 'El jugador eligió Papel y ganó';
          break;
        case 3:
          texto = 'El jugador eligió Tijera y ganó';
          break;
      }

      // Mueve a skeletonIdle a la posición de goblinIdle, realiza la animación de ataque y luego vuelve a su posición original
      // Asegúrate de reemplazar 'SkeletonAttack.png' y 'SkeletonWalking.png' con tus propios sprites
      changeSprite(1, 3);
      updateMovement(1, 1);
      await Future.delayed(const Duration(seconds: 5)); // Espera 1 segundo
      //player1;
    } else if (action != 1 && action != 2 && action != 3) {
      texto = 'El jugador no eligió nada';
    } else if (action == opponentAction) {
      texto = 'Empate';
      empate = true;
    } else {
      // El jugador pierde
      switch (action) {
        case 1:
          texto = 'El jugador eligió Piedra y perdió';
          break;
        case 2:
          texto = 'El jugador eligió Papel y perdió';
          break;
        case 3:
          texto = 'El jugador eligió Tijera y perdió';
          break;
      }

      // Mueve a goblinIdle y realiza la animación de ataque
      changeSprite(2, 3);
      updateMovement(2, 1);
      await Future.delayed(const Duration(seconds: 5)); // Espera 1 segundo
      //player2;
    } // Espera 1 segundo
  }

  @override
  Future<void> onLoad() async {
    final spriteSize = Vector2(150, 600);
    final spriteSize2 = Vector2(150, 1200);

    final screenHeight = canvasSize[0];
    final screenwidth = canvasSize[1];

    var heartSprite = await loadSprite('Hearts_Red.png');
    var spriteSheet1 = await images.load('SkeletonIdle.png');
    var spriteSheet2 = await images.load('GoblinIdle.png');

    SpriteAnimationData spriteData1 = SpriteAnimationData.sequenced(
        amount: 4, stepTime: 0.1, textureSize: spriteSize);

    SpriteAnimationData spriteData2 = SpriteAnimationData.sequenced(
        amount: 4, stepTime: 0.1, textureSize: spriteSize);
    switch (player1character) {
      case 1:
        spriteSheet1 = await images.load('SkeletonIdle.png');
        spriteData1 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: spriteSize);
        break;
      case 2:
        spriteSheet1 = await images.load('GoblinIdle.png');
        spriteData1 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: spriteSize);
        break;
      case 3:
        spriteSheet1 = await images.load('MushIdle.png');
        spriteData1 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.2, textureSize: spriteSize);
        break;
      case 4:
        spriteSheet1 = await images.load('BatFlight.png');
        spriteData1 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.3, textureSize: spriteSize2);
        break;
    }
    switch (player2character) {
      case 1:
        spriteSheet2 = await images.load('SkeletonIdle.png');
        spriteData2 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: spriteSize);
        break;
      case 2:
        spriteSheet2 = await images.load('GoblinIdle.png');
        spriteData2 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: spriteSize);
        break;
      case 3:
        spriteSheet2 = await images.load('MushIdle.png');
        spriteData2 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.3, textureSize: spriteSize);
        break;
      case 4:
        spriteSheet2 = await images.load('BatFlight.png');
        spriteData2 = SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.3, textureSize: spriteSize2);
        break;
    }

    background
      ..sprite = await loadSprite('BackgroundDia.png')
      ..size = canvasSize;
    player1 = SpriteAnimationComponent.fromFrameData(spriteSheet1, spriteData1)
      ..x = 25
      ..y = screenHeight / 4;
    player2 = SpriteAnimationComponent.fromFrameData(spriteSheet2, spriteData2)
      ..x = screenwidth - 20
      ..y = screenHeight / 4;
    player2.flipHorizontally();

    add(background);
    add(player1);
    add(player2);
    for (var i = 0; i < 3; i++) {
      var heart = SpriteComponent(sprite: heartSprite, size: Vector2(32, 32));
      heart.x = (i * 32).toDouble(); // Ajusta la posición x de cada corazón
      heart.y = 5; // Ajusta la posición y de cada corazón
      player1Hearts.add(heart);
      add(heart);
    }
    for (var i = 0; i < 3; i++) {
      var heart = SpriteComponent(sprite: heartSprite, size: Vector2(32, 32));
      heart.x = (screenwidth - 10) -
          (i * 32).toDouble(); // Ajusta la posición x de cada corazón
      heart.y = 5; // Ajusta la posición y de cada corazón
      player2Hearts.add(heart);
      add(heart);
    }
  }

  @override
  void update(double dt) {
    final screenHeight = canvasSize[0];
    final screenwidth = canvasSize[1];
    super.update(dt);
    if (player1movement == 1) {
      if (player1.x < 165) {
        player1.x += dt * movementspeed;
      } else {
        changeSprite(1, 1);
      }
    } else if (player1movement == 3) {
      if (player1.x > 190) {
        player1.x -= dt * movementspeed;
      } else {
        updateMovement(1, 4);
      }
    } else if (player1movement == 4) {
      player1.x = 25;
      player1.y = screenHeight / 4;
      changeSprite(1, 1);
      updateMovement(1, 0);
      if (player2CurrentLifes == 0) {
        changeSprite(2, 5);
        texto = "Ganaste la batalla 🎉";
        onTurnOver(false);
      } else {
        texto = "Turno terminado";
        onTurnOver(true);
      }
    }

    //Personaje enemigo empieza ataque
    if (player2movement == 1) {
      if (player2.x >= 210) {
        player2.x -= dt * movementspeed;
      } else {
        changeSprite(2, 1);
      }
    } else if (player2movement == 3) {
      if (player2.x < 210) {
        player2.x += dt * movementspeed;
      } else {
        updateMovement(2, 4);
      }
    } else if (player2movement == 4) {
      player2.x = screenwidth - 20;
      player2.y = screenHeight / 4;
      changeSprite(2, 1);
      updateMovement(2, 0);
      if (player1CurrentLifes == 0) {
        changeSprite(1, 5);
        texto = "Perdiste la batalla 😔";
        onTurnOver(false);
      } else {
        texto = "Turno terminado";
        onTurnOver(true);
      }
    }
    //Personaje enemigo termino ataque

    //sucedio un empate
    if (empate) {
      changeSprite(1, 1);
      changeSprite(2, 1);
      updateMovement(1, 0);
      updateMovement(2, 0);
      texto = "Termino el empate";
      empate = false;
      onTurnOver(true);
    }
  }

  void updateMovement(int player, int state) {
    switch (player) {
      case 1:
        player1movement = state;
        break;
      case 2:
        player2movement = state;
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final screenHeight = canvasSize[0];
    dialog.render(canvas, texto, Vector2(10, screenHeight - 80));
  }
}
