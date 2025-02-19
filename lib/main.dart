import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NameEntryScreen(),
  ));
}

// Screen to enter pet's name
class NameEntryScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Name Your Pet")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Enter your pet's name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DigitalPetApp(
                          petName: _nameController.text,
                        ),
                      ),
                    );
                  }
                },
                child: Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalPetApp extends StatefulWidget {
  final String petName;

  DigitalPetApp({required this.petName});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  int happinessLevel = 50;
  int hungerLevel = 50;
  late Timer _hungerTimer;
  late Timer _winConditionTimer;
  int _happinessDuration = 0;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinConditionTimer();
  }

  @override
  void dispose() {
    _hungerTimer.cancel();
    _winConditionTimer.cancel();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (!_gameOver) {
        setState(() {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          _updateHappiness();
          _checkGameOver();
        });
      }
    });
  }

  void _startWinConditionTimer() {
    _winConditionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_gameOver) {
        if (happinessLevel > 80) {
          _happinessDuration++;
          if (_happinessDuration >= 180) {
            _showDialog("You Win!", "Your pet stayed happy for 3 minutes!");
            _gameOver = true;
          }
        } else {
          _happinessDuration = 0;
        }
      }
    });
  }

  void _playWithPet() {
    if (_gameOver) return;
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _checkGameOver();
    });
  }

  void _feedPet() {
    if (_gameOver) return;
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkGameOver();
    });
  }

  void _updateHappiness() {
    if (hungerLevel >= 80) {
      happinessLevel = (happinessLevel - 15).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
  }

  void _checkGameOver() {
    if (hungerLevel >= 100 || happinessLevel <= 10) {
      _showDialog("Game Over", "Your pet is too unhappy or too hungry.");
      _gameOver = true;
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_gameOver) Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.greenAccent;
    } else if (happinessLevel >= 30) {
      return Colors.yellowAccent;
    } else {
      return Colors.redAccent;
    }
  }

  String _getMood() {
    if (happinessLevel > 70) {
      return "Happy 😄";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _getPetColor(),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "🐾",
                  style: TextStyle(fontSize: 80),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Name: ${widget.petName}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Mood: ${_getMood()}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel'),
            SizedBox(height: 8.0),
            Text('Hunger Level: $hungerLevel'),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}