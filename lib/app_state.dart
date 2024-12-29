import 'package:flutter/material.dart';

// Model class for Goal
class Goal {
  String goalType;
  int currentValue;
  int targetValue;

  Goal(this.goalType, this.currentValue, this.targetValue);
}

// Model class for Workout
class Workout {
  String workoutType;
  int duration; // in minutes
  int caloriesBurned;
  DateTime time; // exact time of workout

  Workout(this.workoutType, this.duration, this.caloriesBurned, this.time);
}

// State management class
class AppState with ChangeNotifier {
  List<Goal> goals = [];
  List<Workout> workouts = [];

  // Method to add a goal
  void addGoal(String goalType, int targetValue) {
    goals.add(Goal(goalType, 0, targetValue));
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to update a goal
  void updateGoal(Goal goal, String updatedGoalType, int updatedTargetValue) {
    goal.goalType = updatedGoalType;
    goal.targetValue = updatedTargetValue;
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to add a workout
  void addWorkout(String workoutType, int duration, int caloriesBurned, DateTime time) {
    workouts.add(Workout(workoutType, duration, caloriesBurned, time));
    notifyListeners(); // Notify listeners to update UI
  }

  // Get all workouts
  List<Workout> get allWorkouts => workouts;
}
