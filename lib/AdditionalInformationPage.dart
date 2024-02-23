import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String number;
  const AdditionalInformation({
    super.key,
    required this.icon,
    required this.label,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w*0.3,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: h*0.013,),
              Icon(icon,size: 40,),
              SizedBox(height: h*0.018,),
              Text(label,
                style: TextStyle(
                    fontSize: 18
                ),),
              SizedBox(height: h*0.013,),
              Text(number,style:TextStyle(
                  fontSize: 25
              ),)
            ],
          ),
        ),

      ),
    );
  }
}
