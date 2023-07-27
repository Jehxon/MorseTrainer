import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/pages/learning_page.dart';
import 'package:morse_trainer/pages/guess_letter_page.dart';
import 'package:morse_trainer/pages/guess_sound_page.dart';
import 'package:morse_trainer/pages/guess_word_page.dart';
import 'package:morse_trainer/pages/parameters_page.dart';
import 'package:morse_trainer/global.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool initialized = false;

  static final List<Widget> widgetOptions = <Widget>[
    const LearningPage(),
    const GuessLetterPage(),
    const GuessSoundPage(),
    const GuessWordPage(),
    const ParameterPage(),
  ];

  void changePage(int index) {
    Navigator.pop(context);
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
  }

  void loadDict() async{
    wordsDict = await loadWordListFromAsset(AppLocalizations.of(context)!.dictPath);
  }

  @override
  Widget build(BuildContext context) {
    if(!initialized){
      loadDict();
      initialized = true;
    }
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
              title: const Text('Alphabet'),
              onTap: () {
                changePage(0);
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.ear_outline),
              title: Text(AppLocalizations.of(context)!.guessLetterTitle),
              onTap: () {
                changePage(1);
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.pencil),
              title: Text(AppLocalizations.of(context)!.guessSoundTitle),
              onTap: () {
                changePage(2);
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.logo_wordpress),
              title: Text(AppLocalizations.of(context)!.guessWordTitle),
              onTap: () {
                changePage(3);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.parameters),
              onTap: () async {
                changePage(4);
              },
            ),
            const Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context)!.previousPage),
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
