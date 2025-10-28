//
//  GoalManager.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//

//
//import Foundation
//import SwiftData
//import Combine
//
//@MainActor
//public final class GoalManager: ObservableObject {
//    public static let shared = GoalManager()
//    
//    // MARK: - Published
//    @Published public private(set) var currentGoal: GoalModel?
//    @Published public private(set) var didFinishOnboarding: Bool = false
//    @Published public private(set) var learnedDates: [Date] = []
//    @Published public private(set) var freezedDates: [Date] = []
//    
//    private var modelContext: ModelContext?
//    private init() {}
//    
//    // MARK: - Setup
//    public func setModelContext(_ context: ModelContext) {
//        self.modelContext = context
//        loadGoal()
//    }
//    
//    // MARK: - CRUD
//    public func setCurrentGoal(_ goal: GoalModel) {
//        currentGoal = goal
//        learnedDates = goal.learnedDates
//        freezedDates = goal.freezedDates
//        modelContext?.insert(goal)
//        save()
//        didFinishOnboarding = true
//    }
//    
//    public func loadGoal() {
//        guard let context = modelContext else { return }
//        let fetch = FetchDescriptor<GoalModel>()
//        if let first = try? context.fetch(fetch).first {
//            currentGoal = first
//            learnedDates = first.learnedDates
//            freezedDates = first.freezedDates
//            didFinishOnboarding = true
//        } else {
//            didFinishOnboarding = false
//        }
//    }
//    
//    private func save() {
//        do { try modelContext?.save() }
//        catch { print("❌ SwiftData save error:", error) }
//    }
//    
//    // MARK: - Logging
//    public func markDateAsLearned(_ date: Date) {
//        guard let goal = currentGoal else { return }
//        let cal = Calendar.current
//        if !goal.learnedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
//            goal.learnedDates.append(date)
//            learnedDates = goal.learnedDates
//        }
//        goal.currentStreak += 1
//        goal.lastLoggedDate = date
//        save()
//    }
//    
//    public func markDateAsFreezed(_ date: Date) {
//        guard let goal = currentGoal else { return }
//        let cal = Calendar.current
//        if !goal.freezedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
//            goal.freezedDates.append(date)
//            freezedDates = goal.freezedDates
//        }
//        if goal.freezeDaysRemaining > 0 {
//            goal.freezeDaysRemaining -= 1
//        }
//        goal.lastLoggedDate = date
//        save()
//    }
//    
//    // MARK: - Checks
//    public func hasLoggedToday() -> Bool {
//        let cal = Calendar.current
//        if let goal = currentGoal {
//            if goal.learnedDates.contains(where: { cal.isDateInToday($0) }) { return true }
//            if goal.freezedDates.contains(where: { cal.isDateInToday($0) }) { return true }
//            if let last = goal.lastLoggedDate, cal.isDateInToday(last) { return true }
//        }
//        return false
//    }
//    
//    // MARK: - Onboarding
//    public func markOnboardingAsFinished() {
//        didFinishOnboarding = true
//    }
//    
//    // MARK: - Reset
//    public func resetGoal() {
//        if let goal = currentGoal, let context = modelContext {
//            context.delete(goal)
//            try? context.save()
//        }
//        currentGoal = nil
//        learnedDates = []
//        freezedDates = []
//        didFinishOnboarding = false
//    }
//    
//    // MARK: - Refresh
//    public func refreshGoal() {
//        guard let context = modelContext else { return }
//        do {
//            let descriptor = FetchDescriptor<GoalModel>()
//            let results = try context.fetch(descriptor)
//            if let firstGoal = results.first {
//                currentGoal = firstGoal
//                learnedDates = firstGoal.learnedDates
//                freezedDates = firstGoal.freezedDates
//                didFinishOnboarding = true
//            } else {
//                currentGoal = nil
//                learnedDates = []
//                freezedDates = []
//                didFinishOnboarding = false
//            }
//        } catch {
//            print("⚠️ Failed to refresh goals: \(error)")
//        }
//    }
//}


// مضبوط بدون ستريك
//import Foundation
//import SwiftData
//import Combine
//
//@MainActor
//public final class GoalManager: ObservableObject {
//    public static let shared = GoalManager()
//    
//    // MARK: - Published Properties
//    @Published public private(set) var currentGoal: GoalModel?
//    @Published public private(set) var didFinishOnboarding: Bool = false
//    @Published public private(set) var learnedDates: [Date] = []
//    @Published public private(set) var freezedDates: [Date] = []
//    
//    private var modelContext: ModelContext?
//    private init() {}
//    
//    // MARK: - Setup
//    public func setModelContext(_ context: ModelContext) {
//        self.modelContext = context
//        loadGoal()
//    }
//    
//    // MARK: - Goal CRUD
//    public func setCurrentGoal(_ goal: GoalModel) {
//        currentGoal = goal
//        learnedDates = goal.learnedDates
//        freezedDates = goal.freezedDates
//        modelContext?.insert(goal)
//        save()
//        didFinishOnboarding = true
//        // 🔁 تحديث كل الواجهات اللي تراقب GoalManager
//        objectWillChange.send()
//    }
//    
//    public func loadGoal() {
//        guard let context = modelContext else { return }
//        let fetch = FetchDescriptor<GoalModel>()
//        if let first = try? context.fetch(fetch).first {
//            currentGoal = first
//            learnedDates = first.learnedDates
//            freezedDates = first.freezedDates
//            didFinishOnboarding = true
//        } else {
//            didFinishOnboarding = false
//        }
//    }
//    
//    private func save() {
//        try? modelContext?.save()
//    }
//    
//    // MARK: - Logging
////    public func markDateAsLearned(_ date: Date) {
////        guard let goal = currentGoal else { return }
////        let cal = Calendar.current
////        if !goal.learnedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
////            goal.learnedDates.append(date)
////            learnedDates = goal.learnedDates
////        }
////        goal.currentStreak += 1
////        goal.lastLoggedDate = date
////        save()
////        
////    }
//    public func markDateAsLearned(_ date: Date) {
//        guard let goal = currentGoal else { return }
//        let cal = Calendar.current
//        
//        // منع التكرار
//        if !goal.learnedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
//            goal.learnedDates.append(date)
//            learnedDates = goal.learnedDates
//        }
//        
//        goal.currentStreak += 1
//        goal.lastLoggedDate = date
//
//        // 🧪 TEST MODE: لإظهار شاشة Well Done مباشرة بعد أول تعلم (اختبار مؤقت)
//        goal.isCompleted = true
//
//        save()
//        // 🔁 تحديث كل الواجهات اللي تراقب GoalManager
//        objectWillChange.send()
//    }
//    
//    public func markDateAsFreezed(_ date: Date) {
//        guard let goal = currentGoal else { return }
//        let cal = Calendar.current
//        if !goal.freezedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
//            goal.freezedDates.append(date)
//            freezedDates = goal.freezedDates
//        }
//        if goal.freezeDaysRemaining > 0 {
//            goal.freezeDaysRemaining -= 1
//        }
//        goal.lastLoggedDate = date
//        // 🔁 تحديث كل الواجهات اللي تراقب GoalManager
//        objectWillChange.send()
//        save()
//    }
//    
//    // MARK: - Checks
//    public func hasLoggedToday() -> Bool {
//        let cal = Calendar.current
//        if let goal = currentGoal {
//            if goal.learnedDates.contains(where: { cal.isDateInToday($0) }) { return true }
//            if goal.freezedDates.contains(where: { cal.isDateInToday($0) }) { return true }
//            if let last = goal.lastLoggedDate, cal.isDateInToday(last) { return true }
//        }
//        return false
//    }
//    
//    // MARK: - Onboarding
//    public func markOnboardingAsFinished() {
//        didFinishOnboarding = true
//    }
//    
//    // MARK: - Reset
//    public func resetGoal() {
//        if let goal = currentGoal, let context = modelContext {
//            context.delete(goal)
//            try? context.save()
//        }
//        currentGoal = nil
//        learnedDates = []
//        freezedDates = []
//        didFinishOnboarding = false
//        // 🔁 تحديث كل الواجهات اللي تراقب GoalManager
//        objectWillChange.send()
//    }
//    
//    // MARK: - Refresh
//    public func refreshGoal() {
//        guard let context = modelContext else { return }
//        let descriptor = FetchDescriptor<GoalModel>()
//        if let firstGoal = try? context.fetch(descriptor).first {
//            currentGoal = firstGoal
//            learnedDates = firstGoal.learnedDates
//            freezedDates = firstGoal.freezedDates
//            didFinishOnboarding = true
//        } else {
//            currentGoal = nil
//            learnedDates = []
//            freezedDates = []
//            didFinishOnboarding = false
//        }
//    }
//}



//// مضبوط
//import Foundation
//import SwiftData
//import Combine
//
//@MainActor
//public final class GoalManager: ObservableObject {
//    public static let shared = GoalManager()
//    
//    // MARK: - Published Properties
//    @Published public private(set) var currentGoal: GoalModel?
//    @Published public private(set) var didFinishOnboarding: Bool = false
//    @Published public private(set) var learnedDates: [Date] = []
//    @Published public private(set) var freezedDates: [Date] = []
//    
//    private var modelContext: ModelContext?
//    private init() {}
//    
//    // MARK: - Setup
//    public func setModelContext(_ context: ModelContext) {
//        self.modelContext = context
//        loadGoal()
//    }
//    
//    // MARK: - Goal CRUD
////    public func setCurrentGoal(_ goal: GoalModel) {
////        // إعادة التهيئة عند كل هدف جديد (ستريك + فريز)
////        resetProgress(for: goal)
////        
////        currentGoal = goal
////        learnedDates = goal.learnedDates
////        freezedDates = goal.freezedDates
////        modelContext?.insert(goal)
////        save()
////        didFinishOnboarding = true
////        
////        // تحديث الواجهات
////        objectWillChange.send()
////    }
//    
//    public func setCurrentGoal(_ goal: GoalModel) {
//        guard let context = modelContext else { return }
//
//        // 🧹 نحذف أي هدف قديم من قاعدة البيانات عشان ما يتكرّر العرض
//        if let oldGoal = currentGoal {
//            context.delete(oldGoal)
//        }
//
//        // ✨ نحفظ الهدف الجديد كلياً
//        currentGoal = goal
//        learnedDates = goal.learnedDates
//        freezedDates = goal.freezedDates
//
//        context.insert(goal)
//        save()
//        didFinishOnboarding = true
//
//        // تحديث مباشر للواجهات
//        objectWillChange.send()
//    }
//
////    
////    public func loadGoal() {
////        guard let context = modelContext else { return }
////        let fetch = FetchDescriptor<GoalModel>()
////        if let first = try? context.fetch(fetch).first {
////            currentGoal = first
////            learnedDates = first.learnedDates
////            freezedDates = first.freezedDates
////            didFinishOnboarding = true
////            
////            // تأكد من مرور 32 ساعة
////            enforceExpiryIfNeeded()
////        } else {
////            didFinishOnboarding = false
////        }
////    }
//    
//    public func loadGoal() {
//        guard let context = modelContext else { return }
//        // نجلب الأهداف مرتبة بالأحدث
//        var fetch = FetchDescriptor<GoalModel>(
//            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
//        )
//        if let latest = try? context.fetch(fetch).first {
//            currentGoal = latest
//            learnedDates = latest.learnedDates
//            freezedDates = latest.freezedDates
//            didFinishOnboarding = true
//            enforceExpiryIfNeeded()
//        } else {
//            didFinishOnboarding = false
//        }
//    }
//
//    
//    private func save() {
//        try? modelContext?.save()
//    }
//    
//    // MARK: - Logging
//    public func markDateAsLearned(_ date: Date) {
//        guard let goal = currentGoal else { return }
//        let cal = Calendar.current
//
//        // لا تكررين نفس اليوم
//        if goal.learnedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
//            return
//        }
//
//        // تأكدي من مرور 32 ساعة قبل تسجيل
//        enforceExpiryIfNeeded(now: date)
//
//        // منطق الستريك
//        if let last = goal.lastLoggedDate {
//            let hours = date.timeIntervalSince(last) / 3600.0
//            if hours > 32 {
//                goal.currentStreak = 1 // بدأ من جديد
//            } else {
//                goal.currentStreak += 1 // كمل الستريك
//            }
//        } else {
//            goal.currentStreak = 1 // أول يوم
//        }
//
//        goal.learnedDates.append(date)
//        learnedDates = goal.learnedDates
//        goal.lastLoggedDate = date
//
//        // حفظ
//        save()
//        objectWillChange.send()
//    }
//
//    public func markDateAsFreezed(_ date: Date) {
//        guard let goal = currentGoal else { return }
//        let cal = Calendar.current
//
//        // لا تكررين نفس اليوم
//        if goal.freezedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
//            return
//        }
//
//        // تأكدي من مرور 32 ساعة
//        enforceExpiryIfNeeded(now: date)
//
//        // إضافة يوم فريز
//        goal.freezedDates.append(date)
//        freezedDates = goal.freezedDates
//
//        // استهلاك فريز
//        if goal.freezeDaysRemaining > 0 {
//            goal.freezeDaysRemaining -= 1
//        }
//
//        // يعتبر نشاط (يمنع الانقطاع)
//        goal.lastLoggedDate = date
//
//        save()
//        objectWillChange.send()
//    }
//    
//    // MARK: - Checks
//    public func hasLoggedToday() -> Bool {
//        let cal = Calendar.current
//        if let goal = currentGoal {
//            if goal.learnedDates.contains(where: { cal.isDateInToday($0) }) { return true }
//            if goal.freezedDates.contains(where: { cal.isDateInToday($0) }) { return true }
//            if let last = goal.lastLoggedDate, cal.isDateInToday(last) { return true }
//        }
//        return false
//    }
//    
//    // MARK: - Onboarding
//    public func markOnboardingAsFinished() {
//        didFinishOnboarding = true
//    }
//    
//    // MARK: - Reset Goal Completely
//    public func resetGoal() {
//        if let goal = currentGoal, let context = modelContext {
//            context.delete(goal)
//            try? context.save()
//        }
//        currentGoal = nil
//        learnedDates = []
//        freezedDates = []
//        didFinishOnboarding = false
//        objectWillChange.send()
//    }
//    
//    // MARK: - Refresh
////    public func refreshGoal() {
////        guard let context = modelContext else { return }
////        let descriptor = FetchDescriptor<GoalModel>()
////        if let firstGoal = try? context.fetch(descriptor).first {
////            currentGoal = firstGoal
////            learnedDates = firstGoal.learnedDates
////            freezedDates = firstGoal.freezedDates
////            didFinishOnboarding = true
////        } else {
////            currentGoal = nil
////            learnedDates = []
////            freezedDates = []
////            didFinishOnboarding = false
////        }
////    }
//    
//    public func refreshGoal() {
//        guard let context = modelContext else { return }
//        var descriptor = FetchDescriptor<GoalModel>(
//            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
//        )
//        if let latestGoal = try? context.fetch(descriptor).first {
//            currentGoal = latestGoal
//            learnedDates = latestGoal.learnedDates
//            freezedDates = latestGoal.freezedDates
//            didFinishOnboarding = true
//        } else {
//            currentGoal = nil
//            learnedDates = []
//            freezedDates = []
//            didFinishOnboarding = false
//        }
//    }
//
//    
//    
//    // MARK: - Reset Progress (streak + freeze)
//    private func resetProgress(for goal: GoalModel) {
//        goal.currentStreak = 0
//        goal.freezeDaysRemaining = goal.duration.maxFreezeDays()
//        goal.lastLoggedDate = nil
//        goal.learnedDates = []
//        goal.freezedDates = []
//        goal.isCompleted = false
//    }
//
//    // MARK: - 32 Hours Expiry Check
//    public func enforceExpiryIfNeeded(now: Date = Date()) {
//        guard let goal = currentGoal else { return }
//        guard let last = goal.lastLoggedDate else { return }
//
//        let hours = now.timeIntervalSince(last) / 3600.0
//        if hours >= 32, !hasLoggedToday() {
//            resetProgress(for: goal)
//            save()
//            objectWillChange.send()
//        }
//    }
//}




import Foundation
import SwiftData
import Combine

// MARK: - GoalManager Overview
/*
 GoalManager is the central data controller for managing user goals.
 It handles creation, saving, loading, and resetting of goals,
 as well as logic for streak and freeze tracking.
 
 Although this file is relatively long, this is intentional — it acts
 as a unified coordinator during the early stage of development.
 As the app scales, the logic for Streak and Freeze can be refactored
 into separate managers to improve modularity.
 */

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
//    public func setCurrentGoal(_ goal: GoalModel) {
//        guard let context = modelContext else { return }
//
//        // 🧹 نحذف الهدف القديم لتفادي التكرار
//        if let oldGoal = currentGoal {
//            context.delete(oldGoal)
//        }
//
//        // ✨ حفظ الهدف الجديد
//        currentGoal = goal
//        learnedDates = goal.learnedDates
//        freezedDates = goal.freezedDates
//        context.insert(goal)
//        save()
//        didFinishOnboarding = true
//
//        objectWillChange.send()
//    }
    
//    public func setCurrentGoal(_ goal: GoalModel) {
//        guard let context = modelContext else { return }
//
//        // 1) امسح كل الأهداف القديمة نهائيًا
//        if let all = try? context.fetch(FetchDescriptor<GoalModel>()) {
//            for g in all { context.delete(g) }
//            try? context.save()
//        }
//
//        // 2) صفّر تقدّم الهدف الجديد (سيفتي)
//        goal.currentStreak = 0
//        goal.freezeDaysRemaining = goal.duration.maxFreezeDays()
//        goal.lastLoggedDate = nil
//        goal.learnedDates = []
//        goal.freezedDates = []
//        goal.isCompleted = false
//        goal.startDate = Date()
//
//        // 3) خزّن الهدف الجديد
//        currentGoal = goal
//        learnedDates = goal.learnedDates
//        freezedDates = goal.freezedDates
//        context.insert(goal)
//        save()
//        didFinishOnboarding = true
//
//        objectWillChange.send()
//    }

    
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

        // ✅ تحديث فوري لواجهة MainView
        self.freezedDates = goal.freezedDates

        objectWillChange.send()
    }

    
    
    

//    public func loadGoal() {
//        guard let context = modelContext else { return }
//        let fetch = FetchDescriptor<GoalModel>()
//        if let first = try? context.fetch(fetch).first {
//            currentGoal = first
//            learnedDates = first.learnedDates
//            freezedDates = first.freezedDates
//            didFinishOnboarding = true
//            enforceExpiryIfNeeded()
//        } else {
//            didFinishOnboarding = false
//        }
//    }
    
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

        let hours = now.timeIntervalSince(last) / 3600.0
        if hours >= 32, !hasLoggedToday() {
            resetProgress(for: goal)
            save()
            objectWillChange.send()
        }
    }
}
