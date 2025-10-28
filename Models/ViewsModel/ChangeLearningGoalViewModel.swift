//
//  ChangeLearningGoalViewModel.swift
//  L- New
//
//  Created by Maram on 04/05/1447 AH.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class ChangeLearningGoalViewModel: ObservableObject {
    @Published var skillNameInput: String = ""
    @Published var selectedDuration: DurationType? = nil
    @Published var hasChanges: Bool = false

    private let goalManager = GoalManager.shared

    init() {
        if let currentGoal = goalManager.currentGoal {
            self.skillNameInput = currentGoal.skillName
            self.selectedDuration = currentGoal.duration
        }
    }

//    func updateGoal() {
//        guard !skillNameInput.trimmingCharacters(in: .whitespaces).isEmpty,
//              let duration = selectedDuration else { return }
//
//        let newGoal = GoalModel(
//            skillName: skillNameInput.trimmingCharacters(in: .whitespacesAndNewlines),
//            duration: duration
//        )
//
//        goalManager.setCurrentGoal(newGoal)
//
//        goalManager.refreshGoal()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.hasChanges = false
//            self.objectWillChange.send()
//        }
//    }
    
    func updateGoal() {
        guard !skillNameInput.trimmingCharacters(in: .whitespaces).isEmpty,
              let duration = selectedDuration else { return }

        let newGoal = GoalModel(
            skillName: skillNameInput.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: duration
        )

        goalManager.setCurrentGoal(newGoal)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hasChanges = false
            self.objectWillChange.send()
        }
    }


    func onSkillNameChanged(_ text: String) {
        skillNameInput = text
        hasChanges = true
    }

    func onDurationSelected(_ duration: DurationType) {
        DispatchQueue.main.async {
            self.selectedDuration = duration
            self.hasChanges = true
            self.objectWillChange.send()
        }
    }
}
