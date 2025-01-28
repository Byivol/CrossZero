import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lobbydata_inherited.dart';

class ReadyFilledButton extends StatefulWidget {
  const ReadyFilledButton({
    super.key,
  });

  @override
  State<ReadyFilledButton> createState() => _ReadyFilledButtonState();
}

class _ReadyFilledButtonState extends State<ReadyFilledButton> {
  @override
  Widget build(BuildContext context) {
    final lobby = LobbyData.of(context);
    final int currentPlayerIndex = lobby!.lobby.currentPlayer == 'X'
        ? lobby.lobby.players.indexWhere((obj) => obj.nameSymbol == 'X')
        : lobby.lobby.players.indexWhere((obj) => obj.nameSymbol == 'O');
    final String currentPlayerName = currentPlayerIndex != -1
        ? lobby.lobby.players[currentPlayerIndex].namePlayer
        : '';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 300,
      height: 50,
      child: FilledButton(
          style: FilledButton.styleFrom(
            disabledForegroundColor: Colors.white,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color.fromARGB(178, 96, 194, 170),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color.fromRGBO(55, 55, 69, 1),
          ),
          onPressed: () {},
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.roboto(
                letterSpacing: 1,
                fontSize: 16,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: 'Ходит '),
                WidgetSpan(
                  child: Image.network(
                    lobby.lobby.currentPlayer == 'X'
                        ? 'https://i.imgur.com/Dbqbj7X.png'
                        : 'https://i.imgur.com/xaBBOby.png',
                    height: 16,
                    width: 16,
                  ),
                ),
                TextSpan(
                  text: ' $currentPlayerName',
                ),
              ],
            ),
          )),
    );
  }
}
