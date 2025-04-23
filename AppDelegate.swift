//
//  AppDelegate.swift
//  FitSync
//
//  Created by Default User on 3/16/25.
//

import UIKit
import FirebaseCore
import HealthKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var databaseName : String = "dailyGoals.db"
    var databasePath : String = ""

    
    var goals: [DailyGoals] = []

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
       
        // Setup database
                let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDir = documentPath[0]
                databasePath = documentsDir.appending("/" + databaseName)
                
                checkAndCreateDatabase()
                readDailyGoalsFromDatabase()

                return true
    }
    
    func checkAndCreateDatabase() {
        let fm = FileManager.default
        let success = fm.fileExists(atPath: databasePath)
        
        // ✅ Always print the DB path
        print("📁 Database path: \(databasePath)")
        
        if success {
            print("✅ Database already exists at path.")
            return
        }
        
        if let dbPathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName) {
            do {
                try fm.copyItem(atPath: dbPathFromApp, toPath: databasePath)
                print("✅ Database copied to documents directory.")
            } catch {
                print("❌ Error copying database: \(error)")
            }
        } else {
            print("❌ Could not find database in bundle.")
        }
    }

    
    func readDailyGoalsFromDatabase() {
        goals.removeAll()
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            print("Successfully opened DB for DailyGoals")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString = "SELECT * FROM DailyGoals;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(queryStatement, 0))
                    let date = sqlite3_column_text(queryStatement, 1)
                    let stepGoal = Int(sqlite3_column_int(queryStatement, 2))
                    let energyGoal = Int(sqlite3_column_int(queryStatement, 3))
                    let distanceGoal = sqlite3_column_double(queryStatement, 4)
                    let exerciseGoal = Int(sqlite3_column_int(queryStatement, 5))
                    
                    let dateString = date != nil ? String(cString: date!) : ""
                    
                    let goalData = DailyGoals()
                    goalData.initWithData(
                        theRow: id,
                        theDate: dateString,
                        theStep: stepGoal,
                        theEnergy: energyGoal,
                        theDistance: distanceGoal,
                        theExercise: exerciseGoal
                    )
                    goals.append(goalData)
                    
                    print("Goal Row: \(id) - \(dateString) - \(stepGoal) - \(energyGoal) - \(distanceGoal) - \(exerciseGoal)")
                }
                sqlite3_finalize(queryStatement)
            } else {
                print("DailyGoals SELECT could not be prepared")
            }
            
            sqlite3_close(db)
        } else {
            print("Unable to open database for DailyGoals")
        }
    }


    func insertDailyGoals(goal: DailyGoals) -> Bool {
        var db: OpaquePointer? = nil
        var returnCode = true
        
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            print("Inserting Daily Goal...")
            
            var insertStatement: OpaquePointer? = nil
            let insertSQL = """
            INSERT INTO DailyGoals (id, date, stepGoal, energyGoal, distanceGoal, exerciseGoal)
            VALUES (NULL, ?, ?, ?, ?, ?);
            """
            
            if sqlite3_prepare_v2(db, insertSQL, -1, &insertStatement, nil) == SQLITE_OK {
                let dateStr = goal.date! as NSString
                sqlite3_bind_text(insertStatement, 1, dateStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 2, Int32(goal.stepGoal ?? 0))
                sqlite3_bind_int(insertStatement, 3, Int32(goal.energyGoal ?? 0))
                sqlite3_bind_double(insertStatement, 4, goal.distanceGoal ?? 0.0)
                sqlite3_bind_int(insertStatement, 5, Int32(goal.exerciseGoal ?? 0))
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("✅ Inserted DailyGoal at row \(rowID)")
                } else {
                    print("❌ Could not insert DailyGoal")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            } else {
                print("❌ DailyGoal INSERT could not be prepared")
                returnCode = false
            }
            
            sqlite3_close(db)
        } else {
            print("❌ Unable to open DB for DailyGoal insert")
            returnCode = false
        }
        
        return returnCode
    }




    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

