//import 'dart:js';

import 'package:CityWeather/utils.dart';
import 'package:flutter/material.dart';

import 'networking_util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "City Weather",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Visibility(
              visible: false,
              child: PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Search City', 'Refrash'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        body: Center(child: WeatherPage()),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Search City':
        break;
      case 'Refrash':
        postReq("Kolkata").then((val) => {
              //print(val['current'])
              // time = val['current']['observation_time']
            });
        break;
    }
  }
}

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    {
      return _WeatherPageState();
    }
  }
}

class _WeatherPageState extends State<WeatherPage> {
  var _cityInpController = TextEditingController();
  var _time = "";
  var _weatherIco = List();
  var _day = getWeakDay(DateTime.now().weekday);
  var _temperature = "0";
  var _weather_descriptions = List();
  var _location = "";
  @override
  void initState() {
    _cityInpController.text = "Kolkata";
    postReq(_cityInpController.text).then((val) => {
          setState(() {
            _time = val['current']['observation_time'];
            _weatherIco.addAll(val['current']['weather_icons']);
            _weather_descriptions
                .addAll(val['current']['weather_descriptions']);
            _temperature = val['current']['temperature'].toString();
            _location =
                val['location']['name'] + "\n" + val['location']['region'];
            //_day = val['current']['weather_icons'];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepPurple[700],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ListTile(
                title: Text(
                  _day,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  _time,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Image.network(_weatherIco.length > 0 ? _weatherIco[0] : ""),
            Container(
              margin: EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$_temperature° C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 1,
                    margin: EdgeInsets.all(5),
                    height: 30,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        _weather_descriptions.length > 0
                            ? "${_weather_descriptions[0]}"
                            : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _weather_descriptions.length > 0 ? _location : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              color: Colors.white,
              child: TextField(
                controller: _cityInpController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter City'),
              ),
            ),
            RaisedButton(
                child: Text('Refrash'),
                onPressed: () {
                  postReq(_cityInpController.text).then((val) => {
                        setState(() {
                          _time = val['current']['observation_time'];
                          _weatherIco.addAll(val['current']['weather_icons']);
                          _weather_descriptions
                              .addAll(val['current']['weather_descriptions']);
                          _temperature =
                              val['current']['temperature'].toString();

                          _location = val['location']['name'] +
                              "\n" +
                              val['location']['region'];
                          //_day = val['current']['weather_icons'];
                        })
                      });
                })
          ],
        ));
  }

  static String getWeakDay(int weekday) {
    switch (weekday) {
      case 1:
        return "Mondey";
        break;
      case 2:
        return "Tuesday";
        break;
      case 3:
        return "Wednesday";
        break;
      case 4:
        return "Thursday";
        break;
      case 5:
        return "Friday";
        break;
      case 6:
        return "Saterday";
        break;
      case 0:
        return "Sunday";
        break;
      default:
        return "Saterday";
        break;
    }
  }
}
