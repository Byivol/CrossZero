import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:shelf/shelf.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

final Map<String, Lobby> lobbyStore = {};

class Lobby {
  Lobby({required this.idLobby});

  final String idLobby;
  final List<Player> players = [];

  Stopwatch stopwatch = Stopwatch();
  bool isStarted = false;
  String? winnerSymbol;
  List<int> winCombination = [];

  String currentPlayer = 'X';

  List<String> gameField = List.generate(9, (index) => " ");

  static String generateLobbyId() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final id =
        List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return id;
  }

  static List<int> checkVictory(List<String> gameField) {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      final a = gameField[combination[0]];
      final b = gameField[combination[1]];
      final c = gameField[combination[2]];
      if (a != ' ' && a == b && a == c) {
        return combination;
      }
    }

    return [];
  }

  void addPlayer(Player player) {
    if (players.length < 2) {
      if (players.isEmpty) {
        player.nameSymbol = 'X';
      } else {
        player.nameSymbol = players.first.nameSymbol == 'X' ? 'O' : 'X';
      }
      players.add(player);
    }
  }
}

class Player {
  Player(
      {this.nameSymbol = 'X',
      required this.namePlayer,
      required this.connection});

  final String namePlayer;

  WebSocketChannel connection;
  String nameSymbol;
  Map<String, dynamic> toJson() {
    return {'namePlayer': namePlayer, 'nameSymbol': nameSymbol};
  }
}

Map<String, dynamic> getLobbyJson(Lobby lobby) {
  return {
    'duration': lobby.stopwatch.elapsedMilliseconds,
    'answer_action': 'get_lobby',
    'status': 'success',
    'idlobby': lobby.idLobby,
    'isStarted': lobby.isStarted,
    'players': lobby.players.map((player) => player.toJson()).toList(),
    'gameField': lobby.gameField,
    'winnerSymbol': lobby.winnerSymbol,
    'currentPlayer': lobby.currentPlayer,
    'winCombination': lobby.winCombination
  };
}

void broadcastLobby(Lobby? lobby) {
  for (Player player in lobby!.players) {
    player.connection.sink.add(jsonEncode(getLobbyJson(lobby)));
  }
}

Middleware cors() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          HttpHeaders.accessControlAllowOriginHeader: '*',
          HttpHeaders.accessControlAllowMethodsHeader: 'GET, POST, OPTIONS',
          HttpHeaders.accessControlAllowHeadersHeader: 'Content-Type',
        },
      );
    };
  };
}

void main() async {
  final handler = Pipeline()
      .addMiddleware(cors())
      .addHandler(webSocketHandler((WebSocketChannel webSocket) {
    webSocket.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message);
      final action = data['action'];
      switch (action) {
        case 'restart_lobby':
          final lobbyId = data['idlobby'];
          lobbyStore[lobbyId]?.isStarted = false;
          lobbyStore[lobbyId]?.winnerSymbol = null;
          lobbyStore[lobbyId]?.gameField = List.generate(9, (index) => " ");
          lobbyStore[lobbyId]?.winCombination = [];
          lobbyStore[lobbyId]?.stopwatch = Stopwatch();
          if (lobbyStore[lobbyId]?.players.first.nameSymbol !=
              lobbyStore[lobbyId]?.currentPlayer) {
            if (lobbyStore[lobbyId]?.players.first.nameSymbol == 'X') {
              lobbyStore[lobbyId]?.currentPlayer = 'X';
            } else {
              lobbyStore[lobbyId]?.currentPlayer = 'O';
            }
          }
          broadcastLobby(lobbyStore[lobbyId]!);
          break;
        case 'move_player':
          final lobbyId = data['idlobby'];
          final moveIndex = data['moveIndex'];

          if (lobbyStore.containsKey(lobbyId)) {
            final lobby = lobbyStore[lobbyId]!;

            if (lobby.winCombination.isNotEmpty) {
              webSocket.sink.add(jsonEncode({
                'status': 'fail',
                'answer_action_btn': 'Игра уже завершена',
                'idlobby': '$lobbyId',
              }));
              return;
            }
            if (!lobby.stopwatch.isRunning) {
              lobby.stopwatch.start();
            }
            if (lobby.players
                    .firstWhere((obj) => obj.connection == webSocket)
                    .nameSymbol ==
                lobby.currentPlayer) {
              lobby.gameField[moveIndex] = lobby.currentPlayer;

              lobby.winCombination = Lobby.checkVictory(lobby.gameField);

              if (lobby.winCombination.isEmpty &&
                  !lobby.gameField.contains(' ')) {
                lobby.winnerSymbol = 'Draw';
                lobby.stopwatch.stop();
              }

              if (lobby.winCombination.isNotEmpty) {
                lobby.isStarted = false;
                lobby.winnerSymbol = lobby.gameField[lobby.winCombination[0]];
                lobby.stopwatch.stop();
              } else {
                lobby.currentPlayer = lobby.currentPlayer == 'X' ? 'O' : 'X';
                lobby.isStarted = true;
              }
              if (lobbyStore[lobbyId]!.players.length == 1) {
                lobbyStore[lobbyId]!.players.first.nameSymbol =
                    lobbyStore[lobbyId]!.players.first.nameSymbol == 'X'
                        ? 'O'
                        : 'X';
              }
              broadcastLobby(lobby);
            } else {
              webSocket.sink.add(jsonEncode({
                'status': 'fail',
                'answer_action_btn': 'Не ваш ход',
                'idlobby': '$lobbyId',
              }));
            }
          }

          break;

        case 'get_lobby':
          final lobbyId = data['idlobby'];
          if (lobbyStore.containsKey(lobbyId)) {
            webSocket.sink.add(jsonEncode(getLobbyJson(lobbyStore[lobbyId]!)));
          }
          break;
        case 'swap_symbol_player':
          final lobbyId = data['idlobby'];
          if (lobbyStore[lobbyId]!.players.length == 1) {
            lobbyStore[lobbyId]!.players.first.nameSymbol =
                lobbyStore[lobbyId]!.players.first.nameSymbol == 'X'
                    ? 'O'
                    : 'X';
            webSocket.sink.add(jsonEncode(getLobbyJson(lobbyStore[lobbyId]!)));
          }
          if (lobbyStore[lobbyId]!.isStarted) {
            return;
          } else if (lobbyStore.containsKey(lobbyId)) {
            if (lobbyStore[lobbyId]!.players.length == 2) {
              final String firstSymbol =
                  lobbyStore[lobbyId]!.players.first.nameSymbol;
              final String secondSymbol =
                  lobbyStore[lobbyId]!.players.last.nameSymbol;

              lobbyStore[lobbyId]!.players.first.nameSymbol = secondSymbol;
              lobbyStore[lobbyId]!.players.last.nameSymbol = firstSymbol;

              final Player temp = lobbyStore[lobbyId]!.players.first;
              lobbyStore[lobbyId]!.players[0] =
                  lobbyStore[lobbyId]!.players.last;
              lobbyStore[lobbyId]!.players[1] = temp;

              broadcastLobby(lobbyStore[lobbyId]!);
            } else {
              webSocket.sink.add(jsonEncode({
                'status': 'fail',
                'message': 'Invalid number of players to swap symbols',
              }));
            }
          }
          break;

        case 'get_lobby':
          final lobbyId = data['idlobby'];
          if (lobbyStore.containsKey(lobbyId)) {
            webSocket.sink.add(jsonEncode(getLobbyJson(lobbyStore[lobbyId]!)));
          }
          break;
        case 'create_lobby':
          final lobbyId = Lobby.generateLobbyId();

          if (lobbyStore.containsKey(lobbyId)) {
            webSocket.sink.add(jsonEncode(
                {'status': 'error', 'message': 'Lobby already exists'}));
          } else {
            final lobby = Lobby(idLobby: lobbyId);
            lobbyStore.addAll({lobbyId: lobby});
            webSocket.sink.add(jsonEncode({
              'status': 'success',
              'answer_action': 'Lobby created',
              'idlobby': lobbyId,
            }));
          }
          break;
        case 'join_created_lobby':
          final idlobby = data['idlobby'];
          final userName = data['userName'];
          final Player newPlayer =
              Player(namePlayer: userName, connection: webSocket);
          lobbyStore[idlobby]?.addPlayer(newPlayer);
          broadcastLobby(lobbyStore[idlobby]);
          break;
        case 'join_lobby':
          final idlobby = data['idlobby'];
          final userName = data['userName'];

          if (lobbyStore[idlobby] != null) {
            final playerIndex = lobbyStore[idlobby]!.players.indexWhere(
                  (obj) => obj.namePlayer == userName,
                );

            if (playerIndex != -1) {
              final player = lobbyStore[idlobby]!.players[playerIndex];
              if (player.connection != webSocket) {
                player.connection = webSocket;

                webSocket.sink.add(jsonEncode({
                  'answer_action': 'reconnect_lobby',
                  'status': 'success',
                }));
                return;
              }
            } else {
              final Player newPlayer =
                  Player(namePlayer: userName, connection: webSocket);
              lobbyStore[idlobby]?.addPlayer(newPlayer);

              webSocket.sink.add(jsonEncode({
                'answer_action': 'join_lobby',
                'status': 'success',
              }));
            }
          }

          break;
        default:
          webSocket.sink.add(
              jsonEncode({'status': 'error', 'message': 'Unknown action'}));
      }
    }, onDone: () {
      print('Connection closed');
    }, onError: (error) {
      print('Error occurred: $error');
    });
  }));

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  print('Server running on ws://${server.address.host}:${server.port}');
}
