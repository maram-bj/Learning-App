//
//  MainPageViewModel.swift
//  Learning Challeng App
//
//  Created by Maram on 28/04/1447 AH.
//
import Foundation
import SwiftData
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    private let goalManager = GoalManager.shared
    private var context: ModelContext?

    @Published var currentGoal: GoalModel?
    @Published var learnedDates: [Date] = []
    @Published var freezedDates: [Date] = []

    func setup(with context: ModelContext) {
        self.context = context
        goalManager.setModelContext(context)
        goalManager.enforceExpiryIfNeeded()

        if goalManager.currentGoal == nil {
            let tempGoal = GoalModel(skillName: "Swift", duration: .weekly)
            goalManager.setCurrentGoal(tempGoal)
        }

        refreshGoal()
    }

    func logAsLearned() {
        guard !goalManager.hasLoggedToday(), goalManager.currentGoal != nil else { return }
        goalManager.markDateAsLearned(Date())
        refreshGoal()
    }

    func logAsFreezed() {
        guard !goalManager.hasLoggedToday(),
              let goal = goalManager.currentGoal,
              goal.freezeDaysRemaining > 0 else { return }
        goalManager.markDateAsFreezed(Date())
        refreshGoal()
    }

    func refreshGoal() {
        goalManager.refreshGoal()
        currentGoal = goalManager.currentGoal
        learnedDates = goalManager.learnedDates
        freezedDates = goalManager.freezedDates
    }

    var skillName: String {
        currentGoal?.skillName ?? "—"
    }

    var freezeText: String {
        guard let goal = currentGoal else { return "0 out of 6 Freezes used" }
        let max = goal.duration.maxFreezeDays()
        let used = max - goal.freezeDaysRemaining
        return "\(used) out of \(max) Freezes used"
    }

    var streak: Int {
        currentGoal?.currentStreak ?? 0
    }

    var freezeUsed: Int {
        let max = currentGoal?.duration.maxFreezeDays() ?? 0
        let remaining = currentGoal?.freezeDaysRemaining ?? 0
        return max - remaining
    }

    func setSameGoal() {
        guard let old = currentGoal else { return }
        let newGoal = GoalModel(skillName: old.skillName, duration: old.duration)
        goalManager.setCurrentGoal(newGoal)
        refreshGoal()
    }
}
