import 'dart:convert';
import 'dart:ui';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/AdditionalInformationPage.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

import 'WeatherForecastPage.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  late Future<Map<String,dynamic>>weather;
  Future<Map<String,dynamic>> getCurrentInfo() async{
    try {
      String cityname = 'London';
      final result = await http.get(
          Uri.parse(
              'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$APIkey'),
      );
    final data = jsonDecode(result.body);
    if(data['cod'] != '200'){
      throw 'An Error Occurred';
    }
    return data;
    }catch(e){
      throw e.toString();
    }
  }
  @override
  void initState(){
    super.initState();
    weather =  getCurrentInfo();
  }


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App",
      style: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold
      ),),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              weather = getCurrentInfo();
            });
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body:
      FutureBuilder(
        future:weather,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: const CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final CurrentWeatherData = data['list'][0];
          final CurrentTemp = CurrentWeatherData['main']['temp'];
          final CurrentSky = CurrentWeatherData['weather'][0]['main'];
          final CurrentPressure = CurrentWeatherData['main']['pressure'];
          final CurrentWindSpeed = CurrentWeatherData['wind']['speed'];
          final CurrentHumidity = CurrentWeatherData['main']['humidity'];

          return Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  SizedBox(
                    width: w,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 50,
                            sigmaY: 50,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("$CurrentTemp K",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold
                                ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    CurrentSky == 'Clouds' || CurrentSky == 'Rain'? Icons.cloud : Icons.sunny,
                                    size: 45,),
                                ),

                                SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(CurrentSky,
                                    style: TextStyle(
                                      fontSize: 20
                                    ),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text("Weather Forecast",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
              SizedBox(height: 15,),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for (int i=0;i<5;i++)
              //         HourlyForecast(
              //           time: data['list'][i+1]['dt'].toString(),
              //           icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds'
              //           || data['list'][i+1]['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny,
              //           temperature: data['list'][i+1]['main']['temp'].toString(),
              //         ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    final HourlyForcast = data['list'][index+1];
                    final HourlySky = data['list'][index+1]['weather'][0]['main'];
                    final HourlyTemp = HourlyForcast['main']['temp'].toString();
                    final time = DateTime.parse(HourlyForcast['dt_txt']);
                    return HourlyForecast(
                        time:DateFormat.j().format(time),
                        icon: HourlySky=='Clouds' || HourlySky == 'Rain' ? Icons.cloud : Icons.sunny,
                        temperature: HourlyTemp,
                    );
                  }

                )
              ),
              const Padding(
                padding: EdgeInsets.only(top: 17),
                child: Text("Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              SizedBox(height: h*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformation(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    number: CurrentHumidity.toString(),
                  ),
                  AdditionalInformation(
                    icon: Icons.air,
                    label: "Wind Speed",
                    number: CurrentWindSpeed.toString(),
                  ),
                  AdditionalInformation(
                    icon: Icons.beach_access,
                    label: "Pressure",
                    number: CurrentPressure.toString(),
                  ),
                ]
              ),
            ],
          ),
        );
        },
      )
    );
  }
}

