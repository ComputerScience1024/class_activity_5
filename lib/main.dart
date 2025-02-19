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
  int energyLevel = 100; // Energy Bar
  String mood = "Neutral";
  Timer? _hungerTimer;
  String selectedActivity = "Rest";

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  // Hunger increases every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _checkWinLossConditions();
      });
    });
  }

  // Play increases happiness, reduces energy
  void _playWithPet() {
    if (energyLevel <= 0) {
      _showMessage("Your pet is too tired! Let it rest.");
      return;
    }
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinLossConditions();
    });
  }

  // Feed reduces hunger, boosts happiness & energy
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

  // Win if happiness >= 80 for 3 mins, lose if hunger 100 & happiness <= 10
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

  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      energyLevel = 100;
      mood = "Neutral 😐";
    });
  }

void _showMessage(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Reset game after a win or loss
            if (message.contains("You Win") || message.contains("Game Over")) {
              _resetGame();
            }
          },
          child: Text("OK"),
        )
      ],
    ),
  );
}


  // Perform selected activity
  void _performActivity() {
    setState(() {
      if (selectedActivity == "Run") {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
        energyLevel = (energyLevel - 15).clamp(0, 100);
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
      } else if (selectedActivity == "Nap") {
        energyLevel = (energyLevel + 20).clamp(0, 100);
      } else if (selectedActivity == "Play Fetch") {
        happinessLevel = (happinessLevel + 15).clamp(0, 100);
        energyLevel = (energyLevel - 10).clamp(0, 100);
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
      } else if (selectedActivity == "Rest") {
        energyLevel = (energyLevel + 5).clamp(0, 100);
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
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            Text('Mood: $mood', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (mood.contains("Neutral") || mood.contains("Unhappy") || mood.contains("Happy")) ? Colors.transparent : petColor,
              ),
              child: mood.contains("Neutral")
                  ? ClipOval(
                      child: Image.network(
                        'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExbmdhZ3oyM3d3NWhnaGd3N2c1NGs0encyeGEydWs5ODh2c2M2aTZ0NyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l3vR9IEU6nYAmZyoM/giphy.gif',
                        fit: BoxFit.cover,
                      ),
                    )
                  : mood.contains("Unhappy")
                      ? ClipOval(
                          child: Image.network(
                            'https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDY4eTJocjEzc2JycXIxZXNwdzE3MmQxaml3NjVucmhnbXZlaWJ2OCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3269qHKjAEwt0f0tps/giphy.gif',
                            fit: BoxFit.cover,
                          ),
                        )
                      : mood.contains("Happy")
                          ? ClipOval(
                              child: Image.network(
                                'https://media.tenor.com/1x0gVPQEEL8AAAAM/dance-chicken-dance.gif',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(child: Text("🐾", style: TextStyle(fontSize: 50))),
            ),

            SizedBox(height: 16.0),
            _buildStatBar("Happiness", happinessLevel, Colors.pink),
            _buildStatBar("Hunger", hungerLevel, Colors.orange),
            _buildStatBar("Energy", energyLevel, Colors.blue),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: _playWithPet, child: Text('Play with Your Pet')),
            ElevatedButton(onPressed: _feedPet, child: Text('Feed Your Pet')),
            SizedBox(height: 16.0),
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
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: ["Rest", "Run", "Nap", "Play Fetch"]
                  .map<DropdownMenuItem<String>>((String value) {
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

  // Reusable widget for displaying stats with progress bars
  Widget _buildStatBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value', style: TextStyle(fontSize: 18)),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 10,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
