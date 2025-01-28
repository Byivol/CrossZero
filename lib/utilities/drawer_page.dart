import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.transparent,
      width: 200,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => RadialGradient(
              colors: [Color(0xFFEB0057), Color(0xFFE38BAC)],
              radius: 1.0,
              center: Alignment.center,
            ).createShader(bounds),
            child: Text(
              'xoxo',
              style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.normal,
                  fontSize: 32,
                  color: Colors.white),
            ),
          ),
          ListTile(
            title: Text('Игровое поле'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Рейтинг'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Активные игроки'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('История игр'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Список игроков'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
