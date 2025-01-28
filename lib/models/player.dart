class Player {
  Player({required this.namePlayer, required this.nameSymbol});

  final String namePlayer;
  String nameSymbol;

  factory Player.fromJson(Map<String, dynamic> json) {
    String namePlayer = json['namePlayer'];
    String nameSymbol = json['nameSymbol'];

    return Player(
      namePlayer: namePlayer,
      nameSymbol: nameSymbol,
    );
  }

  Map<String, dynamic> toJson() => {
        'namePlayer': namePlayer,
        'nameSymbol': nameSymbol,
      };
}
