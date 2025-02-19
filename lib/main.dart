import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100; // New Energy Bar
  String mood = "Neutral";
  Timer? _hungerTimer;
  String selectedActivity = "Rest";

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  // Function to start hunger timer that increases hunger every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _checkWinLossConditions();
      });
    });
  }

  // Function to update happiness and hunger levels
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinLossConditions();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(0, 100);
      _updateHappiness();
      _checkWinLossConditions();
    });
  }

  void _updateHappiness() {
    if (hungerLevel >= 90) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
    _updateMood();
  }

  void _updateMood() {
    if (happinessLevel > 70) {
      mood = "Happy 😊";
    } else if (happinessLevel >= 30) {
      mood = "Neutral 😐";
    } else {
      mood = "Unhappy 😢";
    }
  }

  // Function to check win/loss conditions
  void _checkWinLossConditions() {
    if (happinessLevel >= 80) {
      Future.delayed(Duration(minutes: 3), () {
        if (happinessLevel >= 80) {
          _showMessage("You Win! 🎉 Your pet is very happy!");
        }
      });
    }
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _showMessage("Game Over! Your pet is too hungry and sad. 😭");
      _resetGame();
    }
  }

  // Reset the game after loss
  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      energyLevel = 100;
      mood = "Neutral 😐";
    });
  }

  // Show game messages
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  // Function to update pet state based on selected activity
  void _performActivity() {
    setState(() {
      if (selectedActivity == "Run") {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
        energyLevel = (energyLevel - 15).clamp(0, 100);
      } else if (selectedActivity == "Nap") {
        energyLevel = (energyLevel + 20).clamp(0, 100);
      } else if (selectedActivity == "Play Fetch") {
        happinessLevel = (happinessLevel + 15).clamp(0, 100);
        energyLevel = (energyLevel - 10).clamp(0, 100);
      }
      _updateHappiness();
      _checkWinLossConditions();
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color petColor = Colors.yellow;
    if (happinessLevel > 70) {
      petColor = Colors.green;
    } else if (happinessLevel < 30) {
      petColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Mood: $mood',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: petColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: _playWithPet, child: Text('Play with Your Pet')),
            ElevatedButton(onPressed: _feedPet, child: Text('Feed Your Pet')),
            SizedBox(height: 16.0),
            // Pet Name Input Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    petName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Enter Pet Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Dropdown for Activity Selection
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: ["Rest", "Run", "Nap", "Play Fetch"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(onPressed: _performActivity, child: Text("Perform Activity")),
          ],
        ),
      ),
    );
  }
}
