//
//  HealthKitManager.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-03-25.
//

import UIKit
import HealthKit

class HealthKitManager: NSObject {
    static let shared = HealthKitManager() // Singleton instance
    let healthStore = HKHealthStore()
    
    // HealthKit Data Types (Steps, Calories, Heart Rate)
    let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
   let activeEnergy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    let appleExerciseTime = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
    let appleStandHour = HKCategoryType.categoryType(forIdentifier: .appleStandHour)!
    let basalEnergyBurned = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
    let distanceWalkingRunning = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//    
//    
//    // Request HealthKit Permissions
//    func requestHealthKitPermissions(completion: @escaping (Bool, Error?) -> Void) {
//        // Check if HealthKit is available
//        guard HKHealthStore.isHealthDataAvailable() else {
//            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit not available on this device."]))
//            return
//        }
//        
//        // Define read-only data types
//        let healthDataToRead: Set = [stepCount, activeEnergy, heartRate, appleExerciseTime, appleStandHour, basalEnergyBurned, distanceWalkingRunning]
//        
//        // Request access
//        healthStore.requestAuthorization(toShare: nil, read: healthDataToRead) { success, error in
//            completion(success, error)
//        }
//    }
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let healthTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
           HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
            HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        ]
     
        healthStore.requestAuthorization(toShare: nil, read: healthTypes) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    // Fetch Steps Count
    func fetchStepCount(completion: @escaping (Double) -> Void) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date()) // Get today's start time
        let endDate = Date() // Now
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            DispatchQueue.main.async {
                completion(steps)
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Calories Burned (Active Energy)
    func fetchCaloriesBurned(completion: @escaping (Double) -> Void) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: activeEnergy, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let calories = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
            DispatchQueue.main.async {
                completion(calories)
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Heart Rate
    func fetchHeartRate(completion: @escaping (Double) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRate, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, _ in
            guard let sample = results?.first as? HKQuantitySample else {
                DispatchQueue.main.async { completion(0) }
                return
            }
            let bpm = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                completion(bpm)
            }
        }
        healthStore.execute(query)
    }
    
    // Move Calories (Active Energy Burned)
//    func fetchActiveEnergyBurned(completion: @escaping (Double) -> Void) {
//        fetchHealthData(for: activeEnergy, unit: .kilocalorie(), completion: completion)
//    }
    
    // Exercise Minutes (Apple Activity Minutes)
    func fetchExerciseMinutes(completion: @escaping (Double) -> Void) {
        fetchHealthData(for: appleExerciseTime, unit: .minute(), completion: completion)
    }
    
    // Walking + Running Distance
    func fetchDistanceWalked(completion: @escaping (Double) -> Void) {
        fetchHealthData(for: distanceWalkingRunning, unit: .meter(), completion: { meters in
            completion(meters / 1000) // Convert to KM
        })
    }
    
    // Stand Hours
    func fetchStandHours(completion: @escaping (Double) -> Void) {
        let type = HKCategoryType.categoryType(forIdentifier: .appleStandHour)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
     
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, _ in
            guard let results = results as? [HKCategorySample] else {
                completion(0)
                return
            }
     
            let standHours = results.filter { $0.value == HKCategoryValueAppleStandHour.stood.rawValue }.count
            completion(Double(standHours))
        }
     
        healthStore.execute(query)
    }
    
    // Resting Energy (Basal Metabolic Rate - BMR)
    func fetchRestingEnergy(completion: @escaping (Double) -> Void) {
        fetchHealthData(for: basalEnergyBurned, unit: .kilocalorie(), completion: completion)
    }
    
    private func fetchHealthData(for type: HKQuantityType, unit: HKUnit, completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let sum = result?.sumQuantity() else { return completion(0) }
            completion(sum.doubleValue(for: unit))
        }
        healthStore.execute(query)
    }
}
