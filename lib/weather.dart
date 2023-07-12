import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _location = '';
  String _temperature = '';
  String _weatherDescription = '';
  String _weatherIconUrl = '';
  String _feelsLike = '';
  String _tempMin = '';
  String _tempMax = '';
  bool _isLoading = false;
  String _errorMessage = '';
  static const Color appColor1 = Color(0xFF5032A5);
  static const Color appColor2 = Color(0xFF8967C7);


  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }

    try {
      final Response response = await get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=rangpur&appid=10a4ae92b9af2fe195240fa60ace4732&units=metric'));

      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final mainData = jsonData['main'];
        final weatherData = jsonData['weather'][0];

        _location = jsonData['name'];
        _temperature = mainData['temp'].toString();
        _weatherDescription = weatherData['description'];
        _feelsLike = mainData['feels_like'].toString();
        _tempMax = mainData['temp_max'].toString();
        _tempMin = mainData['temp_min'].toString();
        _weatherIconUrl =
        'http://openweathermap.org/img/w/${weatherData['icon']}.png';
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      } else {
        _errorMessage = 'Error fetching weather data';
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      _errorMessage = 'Error fetching weather data';
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 104, 66, 218),
        title: const Text('Flutter Weather'),
        centerTitle: false,
        actions: [
          Row(
            children: [
              IconButton(onPressed: (){},icon: const Icon(Icons.settings),),
              IconButton(onPressed: (){},icon: const Icon(Icons.add)),
            ],
          )
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appColor1,appColor2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              else
                Column(
                  children: [
                    const SizedBox(height: 80,),
                    Text(
                      _location,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Updated: ${DateFormat.jm().format(DateTime.now())}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 45),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          _weatherIconUrl,
                          height: 100,
                          width: 80,
                          fit: BoxFit.fill,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.image,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$_temperature°',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Max: $_tempMax°',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              'Min: $_tempMin°',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              'Feels Like: $_feelsLike°',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _weatherDescription,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.white,fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}