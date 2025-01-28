import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/lobby.dart';

class LobbyData extends InheritedWidget {
  final Lobby lobby;
  final WebSocketChannel channel;
  const LobbyData({
    super.key,
    required this.lobby,
    required super.child,
    required this.channel,
  });

  static LobbyData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LobbyData>();
  }

  @override
  bool updateShouldNotify(LobbyData oldWidget) {
    return oldWidget.lobby != lobby;
  }
}
