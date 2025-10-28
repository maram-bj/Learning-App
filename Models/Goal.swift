//
//  Goal.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//

import Foundation
import SwiftData
import Combine

// MARK: - GoalModel
// Stores the user's current learning goal and all progress state.
// Why needed: acts as the single source of truth persisted by SwiftData.
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

// MARK: - StreakModel
// Tracks consecutive activity days (resets after 32 hours gap).
// Why needed: used to show streak fire icon and motivate consistency.
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

        if DateUtils.isStreakExpired(lastDate: last, currentDate: newDate) {
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

// MARK: - FreezeModel
// Manages allowed freeze days and usage dates within a duration.
// Why needed: lets user skip days without breaking streak/progress limits.
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

// MARK: - GoalProgressModel
// Computes derived values (progress %, remaining days, completion).
// Why needed: used by views to render progress without duplicating math.
@MainActor
struct GoalProgressModel {
    let goal: GoalModel

    var learnedCount: Int {
        goal.learnedDates.count
    }

    var freezedCount: Int {
        goal.freezedDates.count
    }

    var totalActiveDays: Int {
        learnedCount + freezedCount
    }

    var requiredDays: Int {
        goal.duration.requiredDays()
    }

    var maxFreezeDays: Int {
        goal.duration.maxFreezeDays()
    }

    var isGoalCompleted: Bool {
        totalActiveDays >= requiredDays
    }

    var progressPercentage: Double {
        min(Double(totalActiveDays) / Double(requiredDays), 1.0)
    }

    var remainingDays: Int {
        max(0, requiredDays - totalActiveDays)
    }
}

// MARK: - GoalModel Extensions
// Bridges to value types (streak/freeze) while persisting raw fields
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
        }
    }
}

// MARK: - GoalManager
// Central coordinator: loads/saves goal, logs learned/freezed, enforces 32h rule
// Why needed: provides a clean API for ViewModels and Views.
@MainActor
public final class GoalManager: ObservableObject {
    public static let shared = GoalManager()
    
    // MARK: - Published Properties
    @Published public private(set) var currentGoal: GoalModel?
    @Published public private(set) var didFinishOnboarding: Bool = false
    @Published public private(set) var learnedDates: [Date] = []
    @Published public private(set) var freezedDates: [Date] = []
    
    private var modelContext: ModelContext?
    private init() {}
    
    // MARK: - Setup
    public func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadGoal()
    }
    
    // MARK: - Goal CRUD
    public func setCurrentGoal(_ goal: GoalModel) {
        guard let context = modelContext else { return }

        // 1) امسح كل الأهداف القديمة
        if let all = try? context.fetch(FetchDescriptor<GoalModel>()) {
            for g in all { context.delete(g) }
            try? context.save()
        }

        // 2) صفّر بيانات الهدف الجديد
        goal.currentStreak = 0
        goal.freezeDaysRemaining = goal.duration.maxFreezeDays()
        goal.lastLoggedDate = nil
        goal.learnedDates = []
        goal.freezedDates = []
        goal.isCompleted = false
        goal.startDate = Date()

        // 3) خزّن الهدف الجديد
        currentGoal = goal
        learnedDates = goal.learnedDates
        freezedDates = goal.freezedDates
        context.insert(goal)
        save()
        didFinishOnboarding = true

        //  تحديث فوري لواجهة MainView
        self.freezedDates = goal.freezedDates

        objectWillChange.send()
    }
    
    public func loadGoal() {
        guard let context = modelContext else { return }
        // نجيب أحدث هدف فقط
        let fetch = FetchDescriptor<GoalModel>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )

        if let first = try? context.fetch(fetch).first {
            currentGoal = first
            learnedDates = first.learnedDates
            freezedDates = first.freezedDates
            didFinishOnboarding = true
            enforceExpiryIfNeeded()
        } else {
            didFinishOnboarding = false
            currentGoal = nil
            learnedDates = []
            freezedDates = []
        }
    }

    private func save() {
        try? modelContext?.save()
    }
    
    // MARK: - Logging: Learned
    public func markDateAsLearned(_ date: Date) {
        guard let goal = currentGoal else { return }
        let cal = Calendar.current
        
        if goal.learnedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
            return
        }

        // تحديث الستريك عبر الموديل
        var streak = goal.streakModel
        streak.update(with: date)
        goal.streakModel = streak

        goal.learnedDates.append(date)
        learnedDates = goal.learnedDates
        
        save()
        objectWillChange.send()
    }

    // MARK: - Logging: Freezed
    public func markDateAsFreezed(_ date: Date) {
        guard let goal = currentGoal else { return }
        let cal = Calendar.current
        
        if goal.freezedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
            return
        }

        var freeze = goal.freezeModel
        if freeze.use(on: date) {
            goal.freezeModel = freeze
            goal.freezedDates.append(date)
            goal.lastLoggedDate = date
            freezedDates = goal.freezedDates
        }

        save()
        objectWillChange.send()
    }
    
    // MARK: - Checks
    public func hasLoggedToday() -> Bool {
        let cal = Calendar.current
        if let goal = currentGoal {
            if goal.learnedDates.contains(where: { cal.isDateInToday($0) }) { return true }
            if goal.freezedDates.contains(where: { cal.isDateInToday($0) }) { return true }
            if let last = goal.lastLoggedDate, cal.isDateInToday(last) { return true }
        }
        return false
    }
    
    // MARK: - Onboarding
    public func markOnboardingAsFinished() {
        didFinishOnboarding = true
    }
    
    // MARK: - Reset Goal Completely
    public func resetGoal() {
        if let goal = currentGoal, let context = modelContext {
            context.delete(goal)
            try? context.save()
        }
        currentGoal = nil
        learnedDates = []
        freezedDates = []
        didFinishOnboarding = false
        objectWillChange.send()
    }
    
    // MARK: - Refresh
    public func refreshGoal() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<GoalModel>()
        if let firstGoal = try? context.fetch(descriptor).first {
            currentGoal = firstGoal
            learnedDates = firstGoal.learnedDates
            freezedDates = firstGoal.freezedDates
            didFinishOnboarding = true
        } else {
            currentGoal = nil
            learnedDates = []
            freezedDates = []
            didFinishOnboarding = false
        }
    }
    
    // MARK: - Reset Progress (Streak + Freeze)
    private func resetProgress(for goal: GoalModel) {
        goal.streakModel = StreakModel()
        var freeze = FreezeModel(max: goal.duration.maxFreezeDays())
        freeze.reset()
        goal.freezeModel = freeze

        goal.learnedDates = []
        goal.freezedDates = []
        goal.lastLoggedDate = nil
        goal.isCompleted = false
    }

    // MARK: - Expiry Check (32 Hours)
    public func enforceExpiryIfNeeded(now: Date = Date()) {
        guard let goal = currentGoal else { return }
        guard let last = goal.lastLoggedDate else { return }

        if DateUtils.isStreakExpired(lastDate: last, currentDate: now), !hasLoggedToday() {
            resetProgress(for: goal)
            save()
            objectWillChange.send()
        }
    }
}
