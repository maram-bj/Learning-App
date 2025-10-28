//
//  OnboardingViewModel.swift
//  Learning Journey
//
//  Created by Maram on 24/04/1447 AH.
//
import Foundation
import Combine

public final class OnboardingViewModel: ObservableObject {
    @Published public var skillNameInput: String = ""
    @Published public var selectedDuration: DurationType? = nil
    @Published public private(set) var isStartLearningButtonEnabled: Bool = false
    @Published public var shouldNavigateToActivity: Bool = false

    private let goalManager = GoalManager.shared
    private var cancellables = Set<AnyCancellable>()

    public init() {
        Publishers.CombineLatest($skillNameInput, $selectedDuration)
            .map { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty && $0.1 != nil }
            .assign(to: \.isStartLearningButtonEnabled, on: self)
            .store(in: &cancellables)
    }

    public func onStartLearningClicked() {
        guard let duration = selectedDuration else { return }
        let goal = GoalModel(skillName: skillNameInput, duration: duration)
        goalManager.setCurrentGoal(goal)
        goalManager.markOnboardingAsFinished()
        shouldNavigateToActivity = true
    }

    public func onDurationSelected(duration: DurationType) {
        selectedDuration = duration
    }
}
