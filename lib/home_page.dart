import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart' as appState;
import 'workout_history_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo Icon
            Image.asset(
              'assets/logo.png', // Path to your logo image
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Fitness Tracker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fitness Goals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fitness Goals",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  // Add Goal Plus Button
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blueAccent, size: 30),
                    onPressed: () => _showAddGoalDialog(context),
                  ),
                ],
              ),
              context.watch<appState.AppState>().goals.isNotEmpty
                  ? Column(
                      children: context.watch<appState.AppState>().goals.map((goal) {
                        return _goalCard(context, goal);
                      }).toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "No goals added yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),

              // View Workout History Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkoutHistoryPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 12,
                    shadowColor: Colors.orangeAccent.withOpacity(0.4),
                  ),
                  child: Text(
                    'View Workout History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Add Workout Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(context),
        backgroundColor: Colors.green,
        child: Icon(Icons.add, size: 30),
        tooltip: 'Add Workout',
      ),
    );
  }

  Widget _goalCard(BuildContext context, appState.Goal goal) {
    double progress = goal.currentValue / goal.targetValue;

    return GestureDetector(
      onTap: () => _showEditGoalDialog(context, goal),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 12),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            leading: Icon(Icons.flag, color: Colors.blueAccent, size: 28),
            title: Text(
              goal.goalType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress: ${goal.currentValue}/${goal.targetValue}',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
                SizedBox(height: 8),
                // Circular Progress Indicator
                CircularProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            trailing: Icon(Icons.edit, color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    TextEditingController goalTypeController = TextEditingController();
    TextEditingController targetValueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Fitness Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(goalTypeController, 'Goal Type'),
              _buildTextField(targetValueController, 'Target Value', keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String goalType = goalTypeController.text;
                final int targetValue = int.tryParse(targetValueController.text) ?? 0;

                if (goalType.isNotEmpty && targetValue > 0) {
                  context.read<appState.AppState>().addGoal(goalType, targetValue);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid goal details.")));
                }
              },
              child: Text('Add', style: TextStyle(fontSize: 16)),
            )
          ],
        );
      },
    );
  }

  void _showAddWorkoutDialog(BuildContext context) {
    TextEditingController workoutTypeController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController caloriesBurnedController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(workoutTypeController, 'Workout Type'),
              _buildTextField(durationController, 'Duration (minutes)', keyboardType: TextInputType.number),
              _buildTextField(caloriesBurnedController, 'Calories Burned', keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String workoutType = workoutTypeController.text;
                final int duration = int.tryParse(durationController.text) ?? 0;
                final int caloriesBurned = int.tryParse(caloriesBurnedController.text) ?? 0;
                final DateTime workoutTime = DateTime.now();

                if (workoutType.isNotEmpty && duration > 0 && caloriesBurned > 0) {
                  context.read<appState.AppState>().addWorkout(workoutType, duration, caloriesBurned, workoutTime);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid workout details.")));
                }
              },
              child: Text('Add', style: TextStyle(fontSize: 16)),
            )
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}

class _showEditGoalDialog {
  _showEditGoalDialog(BuildContext context, appState.Goal goal);
}
