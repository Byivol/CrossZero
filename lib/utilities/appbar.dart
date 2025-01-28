import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'xoxo_icon.dart';

class AppBarNew extends StatefulWidget implements PreferredSizeWidget {
  const AppBarNew({super.key});

  @override
  State<AppBarNew> createState() => _AppBarNewState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  get selectedIndex => null;
}

class _AppBarNewState extends State<AppBarNew> {
  Widget _buildButton(int index, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: widget.selectedIndex == index
            ? Color.fromRGBO(96, 194, 170, 1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        text,
        style: TextStyle(
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: widget.selectedIndex == index ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageButton = [
      _buildButton(0, "Игровое поле"),
      _buildButton(1, "Рейтинг"),
      _buildButton(2, "Активные игроки"),
      _buildButton(3, "История игр"),
      _buildButton(4, "Список игроков")
    ];

    return AppBar(
      elevation: 0.5,
      shadowColor: const Color.fromARGB(96, 0, 0, 0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      toolbarHeight: 60,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
              onDoubleTap: () {
                launchUrl(Uri(path: '/'), webOnlyWindowName: '_self');
              },
              child: XoxoIcon()),
        ),
      ),
      centerTitle: true,
      title: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth - 1 < 800) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            );
          } else {
            return Wrap(
              alignment: WrapAlignment.center,
              children: pageButton,
            );
          }
        },
      ),
    );
  }
}
