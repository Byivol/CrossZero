import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../utilities/appbar.dart';
import '../../utilities/drawer_page.dart';
import '../../models/lobby.dart';
import 'gamefield_widget.dart';
import 'lobbydata_inherited.dart';
import 'playerlist_widget.dart';
import 'readybutton_widget.dart';
import 'stopwatch_widget.dart';

class LobbyPage extends StatefulWidget {
  final String lobbyId;
  final String userName;
  const LobbyPage({super.key, required this.lobbyId, required this.userName});

  @override
  LobbyPageState createState() => LobbyPageState();
}

class LobbyPageState extends State<LobbyPage> {
  late final WebSocketChannel _channel;
  Lobby? _lobby;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://194.190.152.173:8080'));
    _joinLobby();
    _getLobby();
    _channel.stream.listen((message) {
      print(message);

      final Map<String, dynamic> data = jsonDecode(message);
      if (data['answer_action'] == 'get_lobby') {
        setState(() {
          _lobby = Lobby.fromJson(data);
        });
      }
    });
  }

  void _joinLobby() {
    final message = {
      'action': 'join_lobby',
      'idlobby': widget.lobbyId,
      'userName': widget.userName,
    };
    _channel.sink.add(jsonEncode(message));
  }

  void _getLobby() {
    final message = {
      'action': 'get_lobby',
      'idlobby': widget.lobbyId,
    };
    _channel.sink.add(jsonEncode(message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        appBar: AppBarNew(),
        drawer: DrawerPage(),
        body: _lobby == null
            ? Center(child: CircularProgressIndicator())
            : LobbyData(
                lobby: _lobby!,
                channel: _channel,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 1200) {
                      return Wrap(
                        children: [
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PlayerListWidget(padding: EdgeInsets.all(8)),
                                ],
                              ),
                              Center(
                                child: StopwatchWidget(
                                  margin: EdgeInsets.all(32),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Column(
                              children: [
                                GameField(
                                  padding: EdgeInsets.all(8),
                                  weight: 450,
                                  height: 450,
                                ),
                                SizedBox(height: 16),
                                ReadyFilledButton(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (constraints.maxHeight > 500) {
                      return Wrap(
                        children: [
                          Row(
                            children: [
                              PlayerListWidget(padding: EdgeInsets.all(8)),
                              Expanded(
                                child: Center(
                                  child: StopwatchWidget(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8)),
                                ),
                              ),
                            ],
                          ),
                          Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GameField(
                                padding: EdgeInsets.all(8),
                                weight: 450,
                                height: 450,
                              ),
                              ReadyFilledButton()
                            ],
                          ))
                        ],
                      );
                    } else {
                      return Wrap(
                        children: [
                          PlayerListWidget(padding: EdgeInsets.all(8)),
                          Center(
                              child: StopwatchWidget(
                                  margin: EdgeInsets.symmetric(vertical: 8))),
                          Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GameField(
                                padding: EdgeInsets.all(8),
                                weight: 450,
                                height: 450,
                              ),
                              ReadyFilledButton()
                            ],
                          ))
                        ],
                      );
                    }
                  },
                )));
  }
}
