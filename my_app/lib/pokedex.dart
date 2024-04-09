import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'poke_image.dart';
import 'poke_stats.dart';
import 'poke_info.dart';
import 'nav_bar.dart';

void main() => runApp(const MaterialApp(home: PokeDex()));

class PokeDex extends StatefulWidget {
  const PokeDex({super.key});

  @override
  PokeDexState createState() => PokeDexState();
}

class PokeDexState extends State<PokeDex> {
  final TextEditingController _controller = TextEditingController();
  var pokeData = {};
  var stats = {
        'hp': 0.0,
        'attack': 0.0,
        'defense': 0.0,
        'sAttack': 0.0,
        'sDefense': 0.0,
        'speed': 0.0,
      },
      pokeInfo = {
        'id': '',
        'name': '',
        'height': '',
        'weight': '',
        'type': '',
        'nickname': '',
      };
  String? pokeName;
  String pokeTypes = '';
  final String endpoint = 'https://pokeapi.co/api/v2/pokemon';
  final String serverPoint =
      'https://643c0ef24477945573665884.mockapi.io/savedlist/saves';
  String? searchStr;
  String? pokeImage;

  void searchPokemon() async {
    try {var response = await http.get(Uri.parse('$endpoint/$searchStr'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['types'].length > 1) {
        pokeTypes = (data['types'][0]['type']['name'])[0].toUpperCase() +
            (data['types'][0]['type']['name']).substring(1) +
            '/' +
            (data['types'][1]['type']['name'])[0].toUpperCase() +
            (data['types'][1]['type']['name']).substring(1);
      } else {
        pokeTypes = (data['types'][0]['type']['name'])[0].toUpperCase() +
            (data['types'][0]['type']['name']).substring(1);
      }
      setState(() {
        pokeImage = data['name'];
        pokeData = data;
        stats = {
          'hp': data['stats'][0]['base_stat'].toDouble(),
          'attack': data['stats'][1]['base_stat'].toDouble(),
          'defense': data['stats'][2]['base_stat'].toDouble(),
          'sAttack': data['stats'][3]['base_stat'].toDouble(),
          'sDefense': data['stats'][4]['base_stat'].toDouble(),
          'speed': data['stats'][5]['base_stat'].toDouble(),
        };
        pokeInfo = {
          'id': data['id'].toString(),
          'name': data['name'],
          'height': (data['height'] / 10.0).toString(),
          'weight': (data['weight'] / 10.0).toString(),
          'type': pokeTypes,
          'nickname': '',
        };
        pokeName =
            (data['name'])[0].toUpperCase() + (data['name']).substring(1);
      });
      _controller.clear();
    } else {
      // Handle HTTP errors (e.g., 404, 500)
      print('Server error: ${response.statusCode} ${response.reasonPhrase}');
      showErrorDialog('Server error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network errors or invalid JSON
    print('Error: $e');
    showErrorDialog('An error occurred: $e');
  }}

void showErrorDialog(String message) {
  // Show an error dialog or snackbar with the error message
  // For instance, using a dialog (make sure to call this in the right context):
  showDialog(
    context: context, // Ensure you have a BuildContext 'context' available
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  //**not apart of assignment**
  void addPokemon(Map<String, dynamic> pokeData) async {
    var response = await http.post(
      Uri.parse(serverPoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pokeInfo),
    );
    if (response.statusCode == 201) {
      // Handle success **not apart of assignment**
    } else {
      // Handle error **not apart of assignment**
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(
            kToolbarHeight), // remember this sets the bar's size
        child: NavBar(
          title: 'PokéDex',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
              child: Text(
                pokeName == null ? "Who's that pokémon?" : pokeName ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ),
            const SizedBox(height: 20),
            PokeImage(imageUrl: pokeImage),
            const SizedBox(height: 16),
            SizedBox(
              width: 350.0,
              child: TextField(
                  controller: _controller,
                  onChanged: (value) => setState(() => searchStr = value),
                  decoration: InputDecoration(
                    hintText: 'Pokémon name or No.',
                    prefixIcon: const Icon(Icons
                        .search), // Adds a search icon inside the TextField
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ), // Gives a rounded corner to the TextField
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    searchPokemon();
                    _controller.clear();
                  }),
            ),
            
            const SizedBox(height: 10),
            PokeInfo(
              pokeInfo: pokeInfo,
            ),
            PokeStats(stats: stats)
          ],
        ),
      ),
    );
  }
}


