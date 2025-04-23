//
//  HealthKitViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-03-25.
//

import UIKit

class HealthKitViewController: UIViewController {

    @IBOutlet weak var stepCountLabel: UILabel!
        @IBOutlet weak var caloriesLabel: UILabel!
        @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var moveCaloriesLabel: UILabel!
        @IBOutlet weak var exerciseMinutesLabel: UILabel!
        @IBOutlet weak var walkingRunningLabel: UILabel!
        @IBOutlet weak var standHoursLabel: UILabel!
        @IBOutlet weak var restingEnergyLabel: UILabel!
    @IBOutlet var lastUpdatedLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                print("HealthKit authorization granted!")
                self.fetchHealthData()
            } else {
                print("HealthKit authorization denied: \(String(describing: error))")
            }
        }
    }
    @IBAction func unwindToData(sender: UIStoryboardSegue){
        
    }
    

     
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
            fetchHealthData()
        }
     
        func fetchHealthData() {
            let healthKit = HealthKitManager.shared
     
            healthKit.fetchStepCount { steps in
                DispatchQueue.main.async { self.stepCountLabel.text = "\(Int(steps))" }
            }
     
            healthKit.fetchCaloriesBurned { calories in
                DispatchQueue.main.async { self.caloriesLabel.text = "\(Int(calories)) kcal" }
            }
     
            healthKit.fetchHeartRate { bpm in
                DispatchQueue.main.async { self.heartRateLabel.text = "\(Int(bpm)) BPM" }
            }
     
//            healthKit.fetchActiveEnergyBurned { activeEnergy in
//                DispatchQueue.main.async { self.moveCaloriesLabel.text = "Move Calories: \(Int(activeEnergy)) kcal" }
//            }
     
            healthKit.fetchExerciseMinutes { minutes in
                DispatchQueue.main.async { self.exerciseMinutesLabel.text = "\(Int(minutes)) min" }
            }
     
            healthKit.fetchDistanceWalked { distance in
                DispatchQueue.main.async { self.walkingRunningLabel.text = "\(String(format: "%.2f", distance)) km" }
            }
     
            healthKit.fetchStandHours { hours in
                DispatchQueue.main.async { self.standHoursLabel.text = "\(Int(hours)) hrs" }
            }
     
            healthKit.fetchRestingEnergy { restingEnergy in
                DispatchQueue.main.async { self.restingEnergyLabel.text = "\(Int(restingEnergy)) kcal" }
            }
     
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm:ss a"
            self.lastUpdatedLabel.text = "\(formatter.string(from: Date()))"
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


