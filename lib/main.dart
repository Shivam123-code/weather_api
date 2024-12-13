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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WeatherScreen(),
//     );
//   }
// }

// class WeatherScreen extends StatefulWidget {
//   @override
//   _WeatherScreenState createState() => _WeatherScreenState();
// }

// class _WeatherScreenState extends State<WeatherScreen> {
//   final TextEditingController _cityController = TextEditingController();
//   Map<String, dynamic>? _weatherData;

//   Future<void> fetchWeatherData(String city) async {
//     final apiKey = 'ae57d9dc5cda0a2c6a1c77d92252ef2e';
//     final url =
//         'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         setState(() {
//           _weatherData = json.decode(response.body);
//         });
//       } else {
//         setState(() {
//           _weatherData = null;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('City not found!')),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _weatherData = null;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch weather data')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: RadialGradient(
//             colors: [
//               const Color.fromARGB(255, 209, 223, 235),
//               Color.fromARGB(255, 186, 30, 237)
//             ],
//             center: Alignment.topRight,
//             radius: 3,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // Top Center Heading
//               Padding(
//                 padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
//                 child: Text(
//                   'Weather App',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               // Styled TextField with BoxShadow
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10.0,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _cityController,
//                   decoration: InputDecoration(
//                     labelText: 'Enter city name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   fetchWeatherData(_cityController.text);
//                 },
//                 child: Text('Get Weather'),
//               ),
//               SizedBox(height: 16.0),
//               _weatherData != null
//                   ? WeatherTable(weatherData: _weatherData!)
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WeatherTable extends StatelessWidget {
//   final Map<String, dynamic> weatherData;

//   WeatherTable({required this.weatherData});

//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       columns: [
//         DataColumn(label: Text('Parameter')),
//         DataColumn(label: Text('Value')),
//       ],
//       rows: [
//         DataRow(cells: [
//           DataCell(Text('Temperature')),
//           DataCell(Text('${weatherData['main']['temp']} °C')),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('Feels Like')),
//           DataCell(Text('${weatherData['main']['feels_like']} °C')),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('Humidity')),
//           DataCell(Text('${weatherData['main']['humidity']} %')),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('Pressure')),
//           DataCell(Text('${weatherData['main']['pressure']} hPa')),
//         ]),
//         DataRow(cells: [
//           DataCell(Text('Wind Speed')),
//           DataCell(Text('${weatherData['wind']['speed']} m/s')),
//         ]),
//       ],
//     );
//   }
// }
