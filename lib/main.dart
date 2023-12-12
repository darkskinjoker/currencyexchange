import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter App',
      home: MyHomePage(title: 'Currency Exchange'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double exchangeRate = 0.0; // Variable to store the exchange rate
  TextEditingController _controller = TextEditingController();
  String convertedAmount = '';

  Future<void> _fetchExchangeRates() async {
    final String apiUrl = 'https://www.fastforex.io/'; // ExchangeRate-API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Extract the exchange rate from the API response
        setState(() {
          exchangeRate = data['rates']['USD']; // Replace 'USD' with desired currency
          double inputValue = double.tryParse(_controller.text) ?? 0.0;
          convertedAmount = (inputValue * exchangeRate).toStringAsFixed(2);
        });
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _clearConversion() {
    setState(() {
      _controller.clear();
      convertedAmount = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter amount'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchExchangeRates(); // Fetch exchange rates when button is pressed
              },
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount: $convertedAmount', // Display the converted amount
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearConversion,
              child: Text('Clear Conversion'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}