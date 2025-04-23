//
//  NotificationManager.swift
//  FitSync
//
//  Created by Zeel Dobariya on 2025-04-12.
//

import UIKit
import UserNotifications
class NotificationManager: NSObject {

    static let shared = NotificationManager()

        func requestAuthorization() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("✅ Notification permission granted")
                } else {
                    print("❌ Permission denied")
                }
            }
        }

        func scheduleNotification(remainingSteps: Int, remainingEnergy: Int, quote: String) {
            let content = UNMutableNotificationContent()
            content.title = "🚀 Keep Moving!"
            content.body = "You're \(remainingSteps) steps & \(remainingEnergy) kcal away. 💬 \"\(quote)\""
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = 18 // 6 PM

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Notification error: \(error.localizedDescription)")
                } else {
                    print("✅ Notification scheduled")
                }
            }
        }
    }
