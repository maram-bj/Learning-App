//
//  GoalModel.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//
//import Foundation
//import SwiftData
//
//@Model
//public final class GoalModel: Identifiable {
//    public var id: UUID
//    public var skillName: String
//    public var durationRaw: String
//    public var startDate: Date
//    public var freezeDaysRemaining: Int
//    public var lastLoggedDate: Date?
//    public var currentStreak: Int
//    public var isCompleted: Bool
//    public var learnedDates: [Date]
//    public var freezedDates: [Date]
//
//    public var duration: DurationType {
//        get { DurationType(rawValue: durationRaw) ?? .weekly }
//        set { durationRaw = newValue.rawValue }
//    }
//
//    public init(skillName: String, duration: DurationType) {
//        self.id = UUID()
//        self.skillName = skillName
//        self.durationRaw = duration.rawValue
//        self.startDate = Date()
//        self.freezeDaysRemaining = duration.maxFreezeDays()
//        self.lastLoggedDate = nil
//        self.currentStreak = 0
//        self.isCompleted = false
//        self.learnedDates = []
//        self.freezedDates = []
//    }
//    
//}


import Foundation
import SwiftData

@Model
public final class GoalModel: Identifiable {
    public var id: UUID
    public var skillName: String
    public var durationRaw: String
    public var startDate: Date
    public var freezeDaysRemaining: Int
    public var lastLoggedDate: Date?
    public var currentStreak: Int
    public var isCompleted: Bool
    public var learnedDates: [Date]
    public var freezedDates: [Date]
// ARRAY
    public var duration: DurationType {
        get { DurationType(rawValue: durationRaw) ?? .weekly }
        set { durationRaw = newValue.rawValue }
    }

    public init(skillName: String, duration: DurationType) {
        self.id = UUID()
        self.skillName = skillName
        self.durationRaw = duration.rawValue
        self.startDate = Date()
        self.freezeDaysRemaining = duration.maxFreezeDays()
        self.lastLoggedDate = nil
        self.currentStreak = 0
        self.isCompleted = false
        self.learnedDates = []
        self.freezedDates = []
    }
}

// MARK: - GoalModel Logic Bridge
public extension GoalModel {

    // MARK: - Streak Bridge
    var streakModel: StreakModel {
        get {
            StreakModel(current: currentStreak, lastLogged: lastLoggedDate)
        }
        set {
            currentStreak = newValue.current
            lastLoggedDate = newValue.lastLogged
        }
    }

    // MARK: - Freeze Bridge
    var freezeModel: FreezeModel {
        get {
            var model = FreezeModel(max: duration.maxFreezeDays())
            model.remaining = freezeDaysRemaining
            model.usedDates = freezedDates
            return model
        }
        set {
            freezeDaysRemaining = newValue.remaining
            // لو تبين المزامنة بين التواريخ
            // freezedDates = newValue.usedDates
        }
    }
}
