//
//  QuoteProvider.swift
//  FitSync
//
//  Created by  Zeel Dobariya on 2025-04-12.
//

import UIKit

class QuoteProvider: NSObject {
    static let quotes: [String: String] = [
            "No excuses. Just results.": "🔥",
            "You are your only limit.": "🚀",
            "Make it happen.": "🏁",
            "Dream big. Work hard.": "🌟",
            "Discipline = Freedom": "🛡️",
            "Keep going. You're doing great!": "💪",
            "Every step counts.": "👣"
        ]

        static func getRandomQuote() -> (text: String, emoji: String) {
            let random = quotes.randomElement() ?? ("Stay focused!", "📍")
            return (text: random.key, emoji: random.value)
        }

}
