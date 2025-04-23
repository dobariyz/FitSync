//
//  NotificationSettingsViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-04-12.
//

import UIKit
import UserNotifications

class NotificationSettingsViewController: UIViewController {

    @IBOutlet weak var notificationSwitch: UISwitch!

       override func viewDidLoad() {
           super.viewDidLoad()

           // Optional: set switch to ON by default
           notificationSwitch.isOn = true
           
           // Request notification permission once when screen loads
           NotificationManager.shared.requestAuthorization()
       }

       @IBAction func switchToggled(_ sender: UISwitch) {
           if sender.isOn {
               print("🔔 Notifications Enabled")
           } else {
               print("🔕 Notifications Disabled")
               // Optional: remove pending notifications
               UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
           }
       }

    @IBAction func sendTestNotificationTapped(_ sender: UIButton) {
        if notificationSwitch.isOn {
            // 1. Getting set goals from UserDefaults saved in Goal Settings View Controller
            let goalSteps = UserDefaults.standard.integer(forKey: "dailyStepGoal")
            let goalEnergy = UserDefaults.standard.integer(forKey: "dailyEnergyGoal")

            // 2. Fetch current HealthKit values
            HealthKitManager.shared.fetchStepCount { currentSteps in
                HealthKitManager.shared.fetchCaloriesBurned { currentCalories in
                    // 3. Calculate remaining values
                    let remainingSteps = max(0, goalSteps - Int(currentSteps))
                    let remainingEnergy = max(0, goalEnergy - Int(currentCalories))

                    // 4. Get a random quote
                    let quote = QuoteProvider.getRandomQuote()
                    let fullMessage = "\(quote.emoji) \(quote.text)"

                    // 5. Schedule DAILY notification at 6PM
                    NotificationManager.shared.scheduleNotification(
                        remainingSteps: remainingSteps,
                        remainingEnergy: remainingEnergy,
                        quote: fullMessage
                    )

                    // 6. Schedule IMMEDIATE test notification (5 seconds later)
                    let testContent = UNMutableNotificationContent()
                    testContent.title = "🔥 Test Notification"
                    testContent.body = "You're \(remainingSteps) steps & \(remainingEnergy) kcal away.\n💬 \(fullMessage)"
                    testContent.sound = .default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let testRequest = UNNotificationRequest(
                        identifier: UUID().uuidString,
                        content: testContent,
                        trigger: trigger
                    )

                    UNUserNotificationCenter.current().add(testRequest) { error in
                        if let error = error {
                            print("❌ Error sending test notification: \(error.localizedDescription)")
                        } else {
                            print("✅ Test notification scheduled (5 seconds)")
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Notifications Off", message: "Please enable the toggle to receive notifications.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
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
