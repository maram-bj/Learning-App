//
//  StreakModel.swift
//  L- New
//
//  Created by Maram on 04/05/1447 AH.
//

import Foundation

public struct StreakModel {
    public var current: Int
    public var lastLogged: Date?

    public init(current: Int = 0, lastLogged: Date? = nil) {
        self.current = current
        self.lastLogged = lastLogged
    }

    public mutating func update(with newDate: Date) {
        guard let last = lastLogged else {
            current = 1
            lastLogged = newDate
            return
        }

        let hours = newDate.timeIntervalSince(last) / 3600
        if hours > 32 {
            current = 1
        } else {
            current += 1
        }
        lastLogged = newDate
    }

    public mutating func reset() {
        current = 0
        lastLogged = nil
    }
}
