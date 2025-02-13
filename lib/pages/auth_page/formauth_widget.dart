import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FormAuth extends StatefulWidget {
  const FormAuth({super.key});

  @override
  State<FormAuth> createState() => _FormAuthState();
}

class _FormAuthState extends State<FormAuth> {
  bool _isButtonEnabled = false;
  String? _textLogin;
  String? _textPassword;

  final WebSocketChannel _channel =
      WebSocketChannel.connect(Uri.parse('ws://194.190.152.173:8080'));

  final TextEditingController _fcsController = TextEditingController();
  final TextEditingController _idLobbyController = TextEditingController();

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _fcsController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((message) {
      try {
        final data = jsonDecode(message);
        final lobbyId = data['idlobby'];
        launchUrl(Uri(path: '/lobby/$lobbyId/${_fcsController.text}'),
            webOnlyWindowName: '_self');
      } catch (ex) {}
    });
    _fcsController.addListener(_checkFields);
    _idLobbyController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _fcsController.removeListener(_checkFields);
    _idLobbyController.removeListener(_checkFields);
    _idLobbyController.dispose();
    super.dispose();
  }

  void _createLobby() {
    final message = {
      'action': 'create_lobby',
    };
    _channel.sink.add(jsonEncode(message));
  }

  void _joinLobby() {
    final message = {
      'action': 'join_created_lobby',
      'idlobby': _idLobbyController.text,
      'userName': _fcsController.text,
    };
    _channel.sink.add(jsonEncode(message));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 20),
          child: Image.network(
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return CircularProgressIndicator();
              }
            },
            height: 160,
            "https://i.imgur.com/ZKUhbgB.png",
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Войдите в игру",
            style: TextStyle(
                color: Color.fromRGBO(55, 55, 69, 1),
                fontSize: 22,
                fontWeight: FontWeight.w900),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            child: Column(
              spacing: 10,
              children: [
                TextFormField(
                  controller: _fcsController,
                  decoration: InputDecoration(
                    errorText: _textPassword,
                    hintText: "ФИО",
                  ),
                ),
                TextFormField(
                  controller: _idLobbyController,
                  decoration: InputDecoration(
                    errorText: _textLogin,
                    hintText: "ID лобби",
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color.fromARGB(178, 96, 194, 170),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color.fromRGBO(96, 194, 170, 1),
                    ),
                    onPressed: _isButtonEnabled
                        ? () {
                            if (_idLobbyController.text.isNotEmpty) {
                              _joinLobby();
                            } else {
                              _createLobby();
                            }
                          }
                        : null,
                    child: const Text('Войти'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
