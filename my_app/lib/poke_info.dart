import 'package:flutter/material.dart';

class PokeInfo extends StatelessWidget {
  final pokeInfo;
  static const double fSize = 12;
  static const double pSize = 5.0;

  const PokeInfo({
    super.key,
    required this.pokeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0), // Add some margin
      child: Table(
        // Define column widths
        columnWidths: const {
          0: FlexColumnWidth(3.0), // Make the first column smaller
          1: FlexColumnWidth(7.0), // Make the second column wider
        },
        border: TableBorder.all(
          color: Colors.grey, // Add border color
          width: 1.5, // Add border width
        ),
        children: [
          TableRow(children: [
            TableCell(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(pSize), // Add zebra striping
                child: const Text(
                  "National №:",
                  style: TextStyle(fontSize: fSize),
                ), // Add padding
              ),
            ),
            TableCell(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(pSize),
                child: Text(pokeInfo['id'].toString()),
              ),
            ),
          ]),
          TableRow(children: [
            TableCell(
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(pSize), // Add zebra striping
                child: const Text(
                  "Height:",
                  style: TextStyle(fontSize: fSize),
                ), // Add padding
              ),
            ),
            TableCell(
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(pSize), // Add zebra striping
                child: Text(pokeInfo['height'] != ''
                    ? "${pokeInfo['height'].toString()}m"
                    : ''), // Add padding
              ),
            ),
          ]),
          TableRow(children: [
            TableCell(
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(pSize),
                  child: const Text(
                    "Weight:",
                    style: TextStyle(fontSize: fSize),
                  )),
            ), // Add zebra striping
            TableCell(
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(pSize),
                  child: Text(pokeInfo['height'] != ''
                      ? "${pokeInfo['weight'].toString()}Kg"
                      : '')),
            ),
          ]),
          TableRow(children: [
            TableCell(
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(pSize), // Add zebra striping
                child: const Text(
                  "Type:",
                  style: TextStyle(fontSize: fSize),
                ), // Add padding
              ),
            ),
            TableCell(
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(pSize), // Add zebra striping
                child: Text(pokeInfo['type']), // Add padding
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
