import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/widgets/modes/learning_page.dart';
import 'package:morse_trainer/widgets/modes/guess_letter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  static final List<Widget> widgetOptions = <Widget>[
    const LearningPage(),
    const GuessLetterPage(),
  ];

  void changePage(int index) {
    Navigator.pop(context);
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morse Trainer'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/papa_walrus.jpg')
                    ),
              ),
              child: SizedBox.shrink(),
            ),
            ListTile(
              leading: const Icon(Ionicons.book_sharp),
              title: const Text('Apprendre'),
              onTap: () {
                changePage(0);
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.ear_outline),
              title: const Text('Reconnaître'),
              onTap: () {
                changePage(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Mode 3 (TODO =D)'),
              onTap: () { },
            ),
            const Divider(),
            ListTile(
              title: const Text('Précédent'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: widgetOptions[selectedIndex],
    );
  }
}
