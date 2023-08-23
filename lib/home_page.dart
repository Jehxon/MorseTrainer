import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/pages/learning_page.dart';
import 'package:morse_trainer/pages/translator_page.dart';
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
  int selectedIndex = 0; // Index of the selected page in the bottom navigation bar
  bool initialized = false; // Indicates if the page has been initialized
  // List of page widgets to display in the bottom navigation bar
  static final List<Widget> widgetOptions = <Widget>[
    const LearningPage(),
    const TranslatorPage(),
    const GuessLetterPage(),
    const GuessSoundPage(),
    const GuessWordPage(),
    const ParameterPage(),
  ];

  // Function to change the currently displayed page based on the index
  void changePage(int index) {
    Navigator.pop(context); // Close the drawer
    if (index == selectedIndex) return; // If the same page is selected, do nothing
    setState(() {
      selectedIndex = index; // Set the new selected index to update the page
    });
  }

  // Function to load the dictionary of words (if not already loaded) from the assets
  void loadDict() async {
    wordsDict = await loadWordListFromAsset(AppLocalizations.of(context)!.dictPath);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the dictionary when the page is first built
    if (!initialized) {
      loadDict();
      initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Morse Trainer'), // AppBar title
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            // Drawer header with an image
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/papa_walrus.jpg'),
                ),
              ),
              child: SizedBox.shrink(),
            ),
            // List of drawer items representing different pages
            ListTile(
              leading: const Icon(Ionicons.book_sharp),
              title: Text(AppLocalizations.of(context)!.alphabetTitle),
              onTap: () {
                changePage(0); // Go to the Learning Page
              },
            ),
            ListTile(
              leading: const Icon(Icons.change_circle_outlined),
              title: Text(AppLocalizations.of(context)!.translatorTitle),
              onTap: () {
                changePage(1); // Go to the Translator Page
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.ear_outline),
              title: Text(AppLocalizations.of(context)!.guessLetterTitle),
              onTap: () {
                changePage(2); // Go to the Guess Letter Page
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.pencil),
              title: Text(AppLocalizations.of(context)!.guessSoundTitle),
              onTap: () {
                changePage(3); // Go to the Guess Sound Page
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.logo_wordpress),
              title: Text(AppLocalizations.of(context)!.guessWordTitle),
              onTap: () {
                changePage(4); // Go to the Guess Word Page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.parameters),
              onTap: () async {
                changePage(5); // Go to the Parameter Page
              },
            ),
            const Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context)!.previousPage),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      // Display the selected page based on the current index
      body: widgetOptions[selectedIndex],
    );
  }
}
