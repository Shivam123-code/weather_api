import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? _cityName;
  String? _weatherDescription;
  double? _temperature;
  bool _isLoading = false;

  final String _apiKey =
      "ae57d9dc5cda0a2c6a1c77d92252ef2e"; // Replace with your API key

  Future<void> fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
    });

    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _cityName = data['name'];
          _weatherDescription = data['weather'][0]['description'];
          _temperature = data['main']['temp'];
        });
      } else {
        setState(() {
          _cityName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("City not found! Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching weather data.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Enter City Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text.trim();
                if (city.isNotEmpty) {
                  fetchWeather(city);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a city name.")),
                  );
                }
              },
              child: Text("Get Weather"),
            ),
            SizedBox(height: 40),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading && _cityName != null)
              Column(
                children: [
                  Text(
                    "City: $_cityName",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Temperature: ${_temperature?.toStringAsFixed(1)}°C",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Description: $_weatherDescription",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
