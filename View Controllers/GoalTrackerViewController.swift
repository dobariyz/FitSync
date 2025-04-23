//
//  GoalTrackerViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-04-11.
//

import UIKit

class GoalTrackerViewController: UIViewController {
    @IBOutlet var stepGoalLabel: UILabel!
        @IBOutlet var currentStepLabel: UILabel!
        @IBOutlet var stepProgressLabel: UILabel!

        // Energy Goal
        @IBOutlet var energyGoalLabel: UILabel!
        @IBOutlet var currentEnergyLabel: UILabel!
        @IBOutlet var energyProgressLabel: UILabel!

        // Distance Goal
        @IBOutlet var distanceGoalLabel: UILabel!
        @IBOutlet var currentDistanceLabel: UILabel!
        @IBOutlet var distanceProgressLabel: UILabel!

        // Exercise Goal
        @IBOutlet var exerciseGoalLabel: UILabel!
        @IBOutlet var currentExerciseLabel: UILabel!
        @IBOutlet var exerciseProgressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGoalProgress()

        // Do any additional setup after loading the view.
    }
    func loadGoalProgress() {
            // Fetch Goals from UserDefaults
            let stepGoal = UserDefaults.standard.integer(forKey: "dailyStepGoal")
            let energyGoal = UserDefaults.standard.integer(forKey: "dailyEnergyGoal")
            let distanceGoal = UserDefaults.standard.double(forKey: "dailyDistanceGoal")
            let exerciseGoal = UserDefaults.standard.integer(forKey: "dailyExerciseGoal")

            // Show goal values
            stepGoalLabel.text = "Goal: \(stepGoal) steps"
            energyGoalLabel.text = "Goal: \(energyGoal) kcal"
            distanceGoalLabel.text = String(format: "Goal: %.1f km", distanceGoal)
            exerciseGoalLabel.text = "Goal: \(exerciseGoal) mins"

            // Fetch actual values from HealthKit
            let healthKit = HealthKitManager.shared

            healthKit.fetchStepCount { steps in
                DispatchQueue.main.async {
                    self.currentStepLabel.text = "Current: \(Int(steps)) steps"
                    let percent = (steps / Double(stepGoal)) * 100
                    self.stepProgressLabel.text = String(format: "%.0f%% achieved", percent)
                }
            }

            healthKit.fetchCaloriesBurned { energy in
                DispatchQueue.main.async {
                    self.currentEnergyLabel.text = "Current: \(Int(energy)) kcal"
                    let percent = (energy / Double(energyGoal)) * 100
                    self.energyProgressLabel.text = String(format: "%.0f%% achieved", percent)
                }
            }

            healthKit.fetchDistanceWalked { distance in
                DispatchQueue.main.async {
                    self.currentDistanceLabel.text = String(format: "Current: %.2f km", distance)
                    let percent = (distance / distanceGoal) * 100
                    self.distanceProgressLabel.text = String(format: "%.0f%% achieved", percent)
                }
            }

            healthKit.fetchExerciseMinutes { minutes in
                DispatchQueue.main.async {
                    self.currentExerciseLabel.text = "Current: \(Int(minutes)) mins"
                    let percent = (minutes / Double(exerciseGoal)) * 100
                    self.exerciseProgressLabel.text = String(format: "%.0f%% achieved", percent)
                }
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
