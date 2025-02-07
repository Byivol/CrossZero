import 'player.dart';

class Lobby {
  final String idLobby;
  final List<Player> players;
  final List<String> gameField;
  final bool isStarted;
  String? winnerSymbol;
  List<int> winCombination;
  String currentPlayer;
  Duration duration;

  Lobby(
      {required this.idLobby,
      required this.players,
      required this.gameField,
      required this.isStarted,
      required this.currentPlayer,
      required this.winCombination,
      required this.duration,
      required this.winnerSymbol});

  factory Lobby.fromJson(Map<String, dynamic> json) {
    return Lobby(
        duration: Duration(milliseconds: (json['duration'] as int)),
        idLobby: json['idlobby'] as String,
        players: (json['players'] as List)
            .map((playerJson) => Player.fromJson(playerJson))
            .toList(),
        gameField: List<String>.from(json['gameField'] as List),
        isStarted: json['isStarted'] as bool,
        winnerSymbol: json['winnerSymbol'],
        currentPlayer: json['currentPlayer'],
        winCombination: List<int>.from(json['winCombination'] as List));
  }
}
