//
//  FreezeModel.swift
//  L- New
//
//  Created by Maram on 04/05/1447 AH.
//

import Foundation

public struct FreezeModel {
    public var max: Int
    public var remaining: Int
    public var usedDates: [Date]

    public init(max: Int) {
        self.max = max
        self.remaining = max
        self.usedDates = []
    }

    public mutating func use(on date: Date) -> Bool {
        guard remaining > 0 else { return false }
        let cal = Calendar.current
        if !usedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
            usedDates.append(date)
            remaining -= 1
            return true
        }
        return false
    }

    public mutating func reset() {
        remaining = max
        usedDates.removeAll()
    }
}
