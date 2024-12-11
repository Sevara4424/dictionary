import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchScreen(title: 'English to Uzbek Dictionary',),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final String title;
  SearchScreen({Key? key, required this.title}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _translation = "";
  bool _isLoading = false;
  bool _isEnglishToUzbek = true; // To toggle between translation modes

  // Example mock dictionary (could be replaced with API)
  final Map<String, String> _englishToUzbek = {
    'hello': 'salom',
    'goodbye': 'xayr',
    'thank you': 'rahmat',
    'book': 'kitob',
    'world': 'dunyo',
    'pencil': 'qalam',
    'pen': 'ruchka',
    'flower': 'gul',
    'sun': 'quyosh',
    'spring': 'bahor',
  };

  final Map<String, String> _uzbekToEnglish = {
    'salom': 'hello',
    'xayr': 'goodbye',
    'rahmat': 'thank you',
    'kitob': 'book',
    'dunyo': 'world',
    'qalam': 'pencil',
    'ruchka': 'pen',
    'gul': 'flower',
    'quyosh': 'sun',
    'bahor': 'spring',
  };

  // Function to fetch translation based on the mode
  Future<void> fetchTranslation(String word) async {
    setState(() {
      _isLoading = true;
      _translation = "";
    });

    // Simulate a delay to mock API call
    await Future.delayed(Duration(seconds: 2));

    // Check the translation mode
    if (_isEnglishToUzbek) {
      setState(() {
        _translation = _englishToUzbek[word.toLowerCase()] ?? "Translation not found.";
      });
    } else {
      setState(() {
        _translation = _uzbekToEnglish[word.toLowerCase()] ?? "Translation not found.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Function to toggle between translation modes
  void toggleMode() {
    setState(() {
      _isEnglishToUzbek = !_isEnglishToUzbek;
      _controller.clear(); // Clear the input field on mode switch
      _translation = ""; // Clear the translation result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 249, 116, 231),
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEnglishToUzbek ? Icons.arrow_forward : Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: toggleMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field for entering the word
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  labelText: _isEnglishToUzbek
                      ? 'Enter English word'
                      : 'Uzbek tilidagi suzni kiriting',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 164, 42, 154)),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Translate Button
            ElevatedButton(
              onPressed: () {
                fetchTranslation(_controller.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 228, 102, 212),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Translate',
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 31, 30, 31) ),
              ),
            ),
            SizedBox(height: 20),
            // Display Loading or Translation
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _translation.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 253, 224, 251),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _translation,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : SizedBox.shrink(), // Empty space when no translation
          ],
        ),
      ),
    );
  }
}
