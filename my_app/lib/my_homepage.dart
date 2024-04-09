import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100),
                Column(
                  children: <Widget>[
                    Title(color: Colors.black, child: const Text('PokéDex')),
                    Image.asset(
                      "assets/images/PokéDex.png",
                      width: 100, // Set your width and height accordingly
                      height: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/PokéDex');
                      },
                      child: const Text('Open'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: <Widget>[
                    Title(color: Colors.black, child: const Text('My Pokémon')),
                    Image.asset(
                      "assets/images/pokémonMany.png",
                      width: 100, // Set your width and height accordingly
                      height: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/myPokémon');
                      },
                      child: const Text('Coming Soon!'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    Title(color: Colors.black, child: const Text('Stadium')),
                    Image.asset(
                      "assets/images/PokéStadium.png",
                      width: 150, // Adjust the size as needed
                      height: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Stadium');
                      },
                      child: const Text('Coming Soon!'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
