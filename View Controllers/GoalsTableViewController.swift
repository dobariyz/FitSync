

//
//  GoalsTableViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-04-13.
//

import UIKit

class GoalsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var goals: [DailyGoals] = []
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGoalsFromDatabase()
        tableView?.reloadData()
    }

    func loadGoalsFromDatabase() {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.readDailyGoalsFromDatabase()
        goals = mainDelegate.goals
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: GoalDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "goalcell") as? GoalDetailsTableViewCell ?? GoalDetailsTableViewCell(style: .default, reuseIdentifier: "goalcell")
        
        let goal = goals[indexPath.row]

        tableCell.dateLabel.text = "Date: \(goal.date ?? "N/A")"
        tableCell.stepGoalLabel.text = "Steps: \(goal.stepGoal ?? 0)"
        tableCell.energyGoalLabel.text = "Energy: \(goal.energyGoal ?? 0) kcal"
        tableCell.distanceGoalLabel.text = String(format: "Distance: %.1f km", goal.distanceGoal ?? 0.0)
        tableCell.exerciseGoalLabel.text = "Exercise: \(goal.exerciseGoal ?? 0) min"

        return tableCell
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


