import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart' as appState;

class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workouts = context.watch<appState.AppState>().allWorkouts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(Icons.fitness_center, color: Colors.green),
              title: Text(workout.workoutType, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Duration: ${workout.duration} minutes'),
                  Text('Calories Burned: ${workout.caloriesBurned}'),
                  Text('Time: ${workout.time.toLocal()}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
