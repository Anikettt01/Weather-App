import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecast({super.key, required this.time, required this.icon, required this.temperature});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w*0.25,
      child:
      Card(
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
                Text(time,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19
                ),
                maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: h*0.018,),
              Icon(icon,size: 32,),
              SizedBox(height: h*0.018,),
               Text(temperature,
                style: TextStyle(
                    fontSize: 18
                ),),
            ],
          ),

        ),
      ),
    );;
  }
}
