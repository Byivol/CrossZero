import 'dart:convert';

import 'package:flutter/material.dart';

import 'lobbydata_inherited.dart';

class GameField extends StatefulWidget {
  const GameField(
      {super.key,
      this.padding = EdgeInsets.zero,
      required this.weight,
      required this.height});
  final EdgeInsetsGeometry padding;
  final double weight;
  final double height;
  @override
  State<GameField> createState() => GameFieldState();
}

class GameFieldState extends State<GameField> {
  String _getImage(LobbyData lobby, int index) {
    if (lobby.lobby.gameField[index] == 'O') {
      return 'https://i.imgur.com/xaBBOby.png';
    } else if (lobby.lobby.gameField[index] == 'X') {
      return 'https://i.imgur.com/Dbqbj7X.png';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lobby = LobbyData.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          late Color _color;
          if (lobby!.lobby.gameField[index] == 'O' &&
              lobby.lobby.winCombination.contains(index)) {
            _color = Color.fromRGBO(243, 187, 208, 1);
          } else if (lobby.lobby.gameField[index] == 'X' &&
              lobby.lobby.winCombination.contains(index)) {
            _color = Color.fromRGBO(207, 237, 230, 1);
          } else {
            _color = Colors.white;
          }
          return GestureDetector(
              onTap: () {
                if (lobby.lobby.gameField[index] == ' ') {
                  final message = {
                    'action': 'move_player',
                    'idlobby': lobby.lobby.idLobby,
                    'moveIndex': index,
                  };

                  lobby.channel.sink.add(jsonEncode(message));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _color,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(19, 0, 0, 0),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: lobby.lobby.gameField[index] == ' '
                      ? Text(' ')
                      : Image.network(
                          _getImage(lobby, index),
                        ),
                ),
              ));
        },
      ),
    );
  }
}
