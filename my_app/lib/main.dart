import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 3 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Assignment 3 Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String messText = '';

  void messageClear() {
    // Delay for 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messText = ''; // Clearing the messText after 1 second
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is your current count:',
              style: TextStyle(
                  fontSize: Checkbox.width,
                  color: Color.fromARGB(255, 111, 130, 236)),
            ),
            Text('$_counter',
                style: const TextStyle(
                    fontSize:
                        80.0) //Theme.of(context).textTheme.headlineMedium,
                ),
            Text(
              messText,
              style: const TextStyle(color: Colors.red),
            ),
            //const ButtonBar()
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                messText = 'Added 1';
                _counter++;
              });

              messageClear();
            },
            tooltip: 'Increment',
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                messText = 'Removed 1';
                _counter--;
              });

              messageClear();
            },
            tooltip: 'reduction',
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                messText = 'Cleared!';
                _counter = 0;
              });

              messageClear();
            },
            tooltip: 'Clear',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: const Icon(Icons.cancel),
          ),
        ],
      ),
    );
  }
}
