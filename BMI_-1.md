BMI:-1  
import 'package:flutter/material.dart';

void main() {  
  runApp(BMIApp());  
}

class BMIApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      debugShowCheckedModeBanner: false,  
      title: 'BMI Calculator',  
      theme: ThemeData(  
        primarySwatch: Colors.blue,  
      ),  
      home: BMIScreen(),  
    );  
  }  
}

class BMIScreen extends StatefulWidget {  
  @override  
  \_BMIScreenState createState() \=\> \_BMIScreenState();  
}

class \_BMIScreenState extends State\<BMIScreen\> {  
  final TextEditingController weightController \=  
      TextEditingController();

  final TextEditingController heightController \=  
      TextEditingController();

  double bmi \= 0;  
  String result \= "";

  void calculateBMI() {  
    double weight \=  
        double.parse(weightController.text);

    double height \=  
        double.parse(heightController.text);

    // Convert cm to meter  
    height \= height / 100;

    setState(() {  
      bmi \= weight / (height \* height);

      if (bmi \< 18.5) {  
        result \= "Underweight";  
      } else if (bmi \>= 18.5 && bmi \< 24.9) {  
        result \= "Normal";  
      } else if (bmi \>= 25 && bmi \< 29.9) {  
        result \= "Overweight";  
      } else {  
        result \= "Obese";  
      }  
    });  
  }

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text("BMI Calculator"),  
        centerTitle: true,  
      ),  
      body: Padding(  
        padding: EdgeInsets.all(20),  
        child: Column(  
          mainAxisAlignment:  
              MainAxisAlignment.center,  
          children: \[

            TextField(  
              controller: weightController,  
              keyboardType:  
                  TextInputType.number,  
              decoration: InputDecoration(  
                labelText: "Weight (kg)",  
                border: OutlineInputBorder(),  
              ),  
            ),

            SizedBox(height: 20),

            TextField(  
              controller: heightController,  
              keyboardType:  
                  TextInputType.number,  
              decoration: InputDecoration(  
                labelText: "Height (cm)",  
                border: OutlineInputBorder(),  
              ),  
            ),

            SizedBox(height: 30),

            ElevatedButton(  
              onPressed: calculateBMI,  
              child: Text(  
                "Calculate BMI",  
                style: TextStyle(fontSize: 20),  
              ),  
            ),

            SizedBox(height: 30),

            Text(  
              "BMI: ${bmi.toStringAsFixed(2)}",  
              style: TextStyle(  
                fontSize: 28,  
                fontWeight: FontWeight.bold,  
              ),  
            ),

            SizedBox(height: 10),

            Text(  
              result,  
              style: TextStyle(  
                fontSize: 24,  
                color: Colors.blue,  
                fontWeight: FontWeight.bold,  
              ),  
            ),  
          \],  
        ),  
      ),  
    );  
  }  
}  
