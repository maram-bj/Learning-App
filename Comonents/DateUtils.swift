//
//  DateUtils.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//

import Foundation
import SwiftUI

// MARK: - Constants
struct AppConstants {
    static let streakExpiryHours: Double = 32.0
    static let calendar = Calendar.current
}

// MARK: - Date Utilities
struct DateUtils {
    
    // MARK: - Streak Logic
    static func isStreakExpired(lastDate: Date, currentDate: Date = Date()) -> Bool {
        let hours = currentDate.timeIntervalSince(lastDate) / 3600.0
        return hours >= AppConstants.streakExpiryHours
    }
    
    // MARK: - Calendar Operations
    static func isDateInSameDay(_ date1: Date, _ date2: Date) -> Bool {
        AppConstants.calendar.isDate(date1, inSameDayAs: date2)
    }
    
    static func isDateToday(_ date: Date) -> Bool {
        AppConstants.calendar.isDateInToday(date)
    }
    
    static func daysInMonth(_ month: Date) -> [Date] {
        guard let range = AppConstants.calendar.range(of: .day, in: .month, for: month) else { return [] }
        return range.compactMap { day -> Date? in
            AppConstants.calendar.date(byAdding: .day, value: day - 1, to: month)
        }
    }
    
    static func monthsInYear(_ year: Int) -> [Date] {
        return (1...12).compactMap { month -> Date? in
            AppConstants.calendar.date(from: DateComponents(year: year, month: month))
        }
    }
    
    static func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    static func year(for date: Date) -> Int {
        AppConstants.calendar.component(.year, from: date)
    }
}

// MARK: - Goal Status Utilities
struct GoalStatusUtils {
    
    static func getDateStatus(for date: Date, goal: GoalModel?) -> (isLearned: Bool, isFreezed: Bool, isToday: Bool) {
        let isLearned = goal?.learnedDates.contains { DateUtils.isDateInSameDay($0, date) } ?? false
        let isFreezed = goal?.freezedDates.contains { DateUtils.isDateInSameDay($0, date) } ?? false
        let isToday = DateUtils.isDateToday(date)
        
        return (isLearned, isFreezed, isToday)
    }
    
    static func getCircleColor(for date: Date, goal: GoalModel?) -> Color {
        let status = getDateStatus(for: date, goal: goal)
        
        if status.isLearned {
            return Color("Color").opacity(0.27)
        } else if status.isFreezed {
            return Color("Freez").opacity(0.27)
        } else if status.isToday {
            return .orange
        } else {
            return .clear
        }
    }
    
    static func getTextColor(for date: Date, goal: GoalModel?) -> Color {
        let status = getDateStatus(for: date, goal: goal)
        
        if status.isLearned {
            return .orange
        } else if status.isFreezed {
            return Color("Date", bundle: .main) ?? .gray
        } else if status.isToday {
            return .white
        } else {
            return .white.opacity(0.8)
        }
    }
    
    static func getFontWeight(for date: Date, goal: GoalModel?) -> Font.Weight {
        let status = getDateStatus(for: date, goal: goal)
        return (status.isToday || status.isLearned || status.isFreezed) ? .bold : .regular
    }
    
    static func getFontSize(for date: Date, goal: GoalModel?) -> CGFloat {
        let status = getDateStatus(for: date, goal: goal)
        return (status.isToday || status.isLearned || status.isFreezed) ? 16 : 14
    }
}
