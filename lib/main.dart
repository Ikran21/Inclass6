import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));

    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void increment() {
    if (_value < 99) {
      _value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (_value > 0) {
      _value -= 1;
      notifyListeners();
    }
  }

  void setValue(double newValue) {
    _value = newValue.toInt();
    notifyListeners();
  }

  Color get backgroundColor {
    if (_value <= 12) return Colors.lightBlue;
    if (_value <= 19) return Colors.lightGreen;
    if (_value <= 30) return Colors.yellow;
    if (_value <= 50) return Colors.orange;
    return Colors.grey;
  }

  String get message {
    if (_value <= 12) return "You're a child!";
    if (_value <= 19) return "Teenager time!";
    if (_value <= 30) return "You're a young adult!";
    if (_value <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  Color get progressBarColor {
    if (_value <= 33) return Colors.green;
    if (_value <= 67) return Colors.yellow;
    return Colors.red;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var counter = context.watch<Counter>();

    return Scaffold(
      backgroundColor: counter.backgroundColor,
      appBar: AppBar(
        title: const Text('Flutter Age Counter'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your Age:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                counter.message,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Progress Bar
              LinearProgressIndicator(
                value: counter.value / 99, // Normalize between 0 and 1
                color: counter.progressBarColor,
                backgroundColor: Colors.grey[300],
                minHeight: 10,
              ),
              const SizedBox(height: 20),

              // Age Slider
              Slider(
                value: counter.value.toDouble(),
                min: 0,
                max: 99,
                divisions: 99,
                label: '${counter.value}',
                onChanged: (newValue) {
                  counter.setValue(newValue);
                },
              ),
            ],
          ),
        ),
      ),

      // Buttons for Increment and Decrement
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: counter.decrement,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: counter.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
