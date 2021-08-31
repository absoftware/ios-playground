//: [Previous](@previous)

import Foundation

extension TimeZone {

    func utcDescription(for date: Date = Date()) -> String {
        var seconds = self.secondsFromGMT(for: date)
        let negative = seconds < 0
        seconds = abs(seconds)
        let minutes = (seconds % 3600) / 60
        let hours = seconds / 3600
        return String(format: "UTC %@%02d:%02d", negative ? "-" : "+", hours, minutes)
    }
}

let now = Date()
for (index, timeZoneId) in TimeZone.knownTimeZoneIdentifiers.enumerated() {
    guard let timeZone = TimeZone(identifier: timeZoneId) else {
        continue
    }
    print("[\(index)] \(timeZone.identifier) \(timeZone.utcDescription(for: now))")
}

//: [Next](@next)
