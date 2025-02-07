import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lobbydata_inherited.dart';

class PlayerListWidget extends StatefulWidget {
  const PlayerListWidget({super.key, required this.padding});
  final EdgeInsetsGeometry padding;

  @override
  State<PlayerListWidget> createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  @override
  Widget build(BuildContext context) {
    final lobby = LobbyData.of(context);

    if (lobby == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: widget.padding,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(19, 0, 0, 0),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Игроки",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  Spacer(),
                  Text('ID лобби: ', style: TextStyle(fontSize: 14)),
                  GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: lobby.lobby.idLobby));
                      },
                      child: Column(
                        children: [
                          Text('${lobby.lobby.idLobby}  ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14)),
                        ],
                      )),
                ],
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                Column(
                  children: lobby.lobby.players.map((player) {
                    return ListTile(
                      leading: Image.network(
                        player.nameSymbol == 'X'
                            ? 'https://i.imgur.com/Dbqbj7X.png'
                            : 'https://i.imgur.com/xaBBOby.png',
                        width: 30,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      title: SelectableText(
                        player.namePlayer,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '0% побед',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 78, 78, 78),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                !lobby.lobby.isStarted
                    ? IconButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        splashRadius: 12,
                        iconSize: 32,
                        onPressed: () {
                          final message = {
                            'action': 'swap_symbol_player',
                            'idlobby': lobby.lobby.idLobby,
                          };

                          lobby.channel.sink.add(jsonEncode(message));
                        },
                        icon: Icon(Icons.sync_sharp))
                    : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
