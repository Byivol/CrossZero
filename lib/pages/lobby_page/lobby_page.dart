import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool isVisibleModal = false;
  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://194.190.152.173:8080'));
    _joinLobby();
    _getLobby();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      _getLobby();
    });
    _channel.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message);
      if (data['answer_action'] == 'get_lobby') {
        setState(() {
          _lobby = Lobby.fromJson(data);
          if (_lobby?.winnerSymbol != null) {
            final int? currentPlayerIndex = _lobby!.currentPlayer == 'X'
                ? _lobby?.players.indexWhere((obj) => obj.nameSymbol == 'X')
                : _lobby?.players.indexWhere((obj) => obj.nameSymbol == 'O');
            final String? currentPlayerName = currentPlayerIndex != -1
                ? _lobby?.players[currentPlayerIndex!].namePlayer
                : '';
            if (_lobby!.winnerSymbol!.isNotEmpty && !isVisibleModal) {
              isVisibleModal = true;
              showDialog(
                barrierColor: Colors.transparent,
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Container(
                        width: 300,
                        height: 350,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(249, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(68, 0, 0, 0),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                child: Image.network(
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                  height: 160,
                                  "https://i.imgur.com/wTiRoyV.png",
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.roboto(
                                          color: Color.fromRGBO(55, 55, 69, 1),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900),
                                      children: _lobby?.winnerSymbol == 'Draw'
                                          ? [
                                              TextSpan(text: 'Ничья!'),
                                            ]
                                          : [
                                              TextSpan(text: 'Победил '),
                                              WidgetSpan(
                                                child: Image.network(
                                                  _lobby?.winnerSymbol == 'X'
                                                      ? 'https://i.imgur.com/Dbqbj7X.png'
                                                      : 'https://i.imgur.com/xaBBOby.png',
                                                  height: 22,
                                                  width: 22,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' $currentPlayerName',
                                              ),
                                            ],
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      disabledForegroundColor: Colors.white,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          const Color.fromARGB(
                                              178, 96, 194, 170),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor:
                                          const Color.fromRGBO(96, 194, 170, 1),
                                    ),
                                    onPressed: () {
                                      _restartLobby();
                                      Future.delayed(
                                          Duration(milliseconds: 300));
                                      Navigator.pop(context);
                                      isVisibleModal = false;
                                    },
                                    child: const Text(
                                      'Новая игра',
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      disabledForegroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      disabledBackgroundColor:
                                          const Color.fromARGB(
                                              178, 96, 194, 170),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: const Color.fromRGBO(
                                          247, 247, 247, 1),
                                    ),
                                    onPressed: () {
                                      launchUrl(Uri(path: '/'),
                                          webOnlyWindowName: '_self');
                                    },
                                    child: const Text(
                                      'Выйти в меню',
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ])),
                  );
                },
              );
            }
          }
        });
      }
    });
  }

  void _restartLobby() {
    final message = {'action': 'restart_lobby', 'idlobby': widget.lobbyId};
    _channel.sink.add(jsonEncode(message));
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
        backgroundColor: Colors.white,
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
                    if (constraints.maxWidth < 600 ||
                        constraints.maxHeight < 600) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                PlayerListWidget(padding: EdgeInsets.all(8)),
                                Flexible(
                                  child: Center(
                                    child: StopwatchWidget(
                                        margin: EdgeInsets.all(2)),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 8, right: 8),
                                    child: SizedBox(
                                      child: GameField(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: ReadyFilledButton(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Wrap(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PlayerListWidget(padding: EdgeInsets.all(8)),
                              ],
                            ),
                            Center(
                              child: StopwatchWidget(
                                margin: EdgeInsets.all(32),
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 450, maxWidth: 450),
                                      child: GameField(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ReadyFilledButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )));
  }
}
