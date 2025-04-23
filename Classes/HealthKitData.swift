//
//  HealthKitData.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-03-25.
//

import UIKit

class HealthKitData: NSObject {
    
    var id: Int?
    var date: String?
    var stepCount: Int?
    var caloriesBurned: Double?
    var heartRate: Double?
    var moveCalories: Double?
    var exerciseMinutes: Int?
    var walkingRunningDistance: Double?
    var standHours: Int?
    var restingEnergy: Double?
    
    func initWithData(theRow i: Int, theDate d: String, theStepCount sc: Int, theCaloriesBurned cb: Double, theHeartRate hr: Double, theMoveCalories mc: Double, theExerciseMinutes em: Int, theWalkingRunningDistance wrd: Double, theStandHours sh: Int, theRestingEnergy re: Double) {
        id = i
        date = d
        stepCount = sc
        caloriesBurned = cb
        heartRate = hr
        moveCalories = mc
        exerciseMinutes = em
        walkingRunningDistance = wrd
        standHours = sh
        restingEnergy = re
    }

}
