//
//  GoalSettingViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-04-11.
//

import UIKit

class GoalSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var stepGoalPicker: UIPickerView!
    @IBOutlet weak var energyGoalPicker: UIPickerView!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var exerciseSlider: UISlider!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var exerciseValueLabel: UILabel!

    let stepOptions = Array(stride(from: 1000, through: 20000, by: 1000)) // Steps: 1000 to 20000
    let energyOptions = Array(stride(from: 100, through: 1000, by: 50))   // Energy: 100 to 1000 kcal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceValueLabel.text = String(format: "%.1f km", distanceSlider.value)
        exerciseValueLabel.text = "\(Int(exerciseSlider.value)) min"

        
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? stepOptions.count : energyOptions.count
    }
    
    // MARK: - PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? "\(stepOptions[row]) steps" : "\(energyOptions[row]) kcal"
    }
    @IBAction func distanceSliderChanged(_ sender: UISlider) {
        let value = String(format: "%.1f km", sender.value)
        distanceValueLabel.text = value
    }

    @IBAction func exerciseSliderChanged(_ sender: UISlider) {
        let value = "\(Int(sender.value)) min"
        exerciseValueLabel.text = value
    }

    
    // MARK: - Save Button Action
    @IBAction func saveGoalsButtonTapped(_ sender: UIButton) {
        let selectedStepGoal = stepOptions[stepGoalPicker.selectedRow(inComponent: 0)]
        let selectedEnergyGoal = energyOptions[energyGoalPicker.selectedRow(inComponent: 0)]
        let selectedDistanceGoal = Double(distanceSlider.value) // in km
        let selectedExerciseMinutes = Int(exerciseSlider.value)
        
        // 1. Save to UserDefaults
        UserDefaults.standard.set(selectedStepGoal, forKey: "dailyStepGoal")
        UserDefaults.standard.set(selectedEnergyGoal, forKey: "dailyEnergyGoal")
        UserDefaults.standard.set(selectedDistanceGoal, forKey: "dailyDistanceGoal")
        UserDefaults.standard.set(selectedExerciseMinutes, forKey: "dailyExerciseGoal")
        
        // 2. Prepare object for SQLite
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let goal = DailyGoals()
        goal.initWithData(
            theRow: 0,
            theDate: formatter.string(from: Date()),
            theStep: selectedStepGoal,
            theEnergy: selectedEnergyGoal,
            theDistance: selectedDistanceGoal,
            theExercise: selectedExerciseMinutes
        )
        
        // 3. Calling  AppDelegate to save into database
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let success = appDelegate.insertDailyGoals(goal: goal)
            print(success ? "✅ Goal saved to database." : "❌ Failed to save goal to database.")
        }

        // 4. Confirmation alert
        let alert = UIAlertController(title: "Saved ✅", message: "Your daily goals have been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
