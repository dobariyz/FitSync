//
//  DailyGoals.swift
//  FitSync
//
//  Created by Viraj Barvalia on 2025-04-12.
//

import UIKit

class DailyGoals: NSObject {
        var id: Int?
        var date: String?
        var stepGoal: Int?
        var energyGoal: Int?
        var distanceGoal: Double?
        var exerciseGoal: Int?

        func initWithData(theRow: Int, theDate: String, theStep: Int, theEnergy: Int, theDistance: Double, theExercise: Int) {
            id = theRow
            date = theDate
            stepGoal = theStep
            energyGoal = theEnergy
            distanceGoal = theDistance
            exerciseGoal = theExercise
        }

}
