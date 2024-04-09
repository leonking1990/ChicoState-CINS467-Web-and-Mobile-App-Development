import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String title;
  const NavBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,),
      actions: <Widget>[
        // Assuming your Links widget is equivalent to having multiple navigation links
        PopupMenuButton(
          onSelected: (value) {
            // Handle navigation based on value
            Navigator.pushNamed(context, value.toString());
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: '/',
              child: Text('Home'),
            ),
            const PopupMenuItem(
              value: '/PokéDex',
              child: Text('PokéDex'),
            ),
            const PopupMenuItem(
              value: '/myPokémon',
              child: Tooltip(
                  message: 'Coming Soon!',
                  child:
                      Text('My Pokémon', style: TextStyle(color: Colors.grey))),
            ),
            const PopupMenuItem(
              value: '/Stadium',
              child: Tooltip(
                message: 'Coming soon!',
                child: Text(
                  'Stadium',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            // Add more links as needed
          ],
        ),
      ],
    );
  }
}
