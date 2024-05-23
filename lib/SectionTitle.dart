import 'package:final_project/Top100List.dart';
import 'package:final_project/top100Page.dart';

import 'explorePage.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Top100List top100;

  const SectionTitle({super.key, required this.title, required this.top100});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(
            child: title == 'Upcoming'
                ? const Text('explore >')
                : const Text('top 100 >'),
            onPressed: () {
              if (title == 'Upcoming') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplorePage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Top100Page(top100List: top100,),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
