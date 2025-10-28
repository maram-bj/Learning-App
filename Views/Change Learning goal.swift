////
////  Change Learning goal.swift
////  Learning Challeng App
////
////  Created by Maram on 29/04/1447 AH.
////
import SwiftUI
import Combine

public struct ChangeLearningGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChangeLearningGoalViewModel()
    @State private var showAlert = false

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 40) {

            // MARK: - Skill Input
            VStack(alignment: .leading, spacing: 4) {
                Text("I want to learn")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)

                ZStack(alignment: .leading) {
                    if viewModel.skillNameInput.isEmpty {
                        Text("Swift")
                            .foregroundColor(.gray)
                            .font(.system(size: 17))
                    }

                    TextField("", text: $viewModel.skillNameInput)
                        .foregroundColor(.white)
                        .onChange(of: viewModel.skillNameInput) { newValue in
                            viewModel.onSkillNameChanged(newValue)
                        }
                }
                .padding(.vertical, 14)

                Divider()
                    .background(Color.gray.opacity(0.5))
            }

            // MARK: - Duration Buttons (نفس تصميم Onboarding)
            VStack(alignment: .leading, spacing: 14) {
                Text("I want to learn it in a")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    chossebutton(title: "Week", isSelected: Binding(
                        get: { viewModel.selectedDuration?.rawValue ?? "" },
                        set: { newValue in
                            if let duration = DurationType(rawValue: newValue) {
                                viewModel.onDurationSelected(duration)
                            }
                        }
                    ))

                    chossebutton(title: "Month", isSelected: Binding(
                        get: { viewModel.selectedDuration?.rawValue ?? "" },
                        set: { newValue in
                            if let duration = DurationType(rawValue: newValue) {
                                viewModel.onDurationSelected(duration)
                            }
                        }
                    ))

                    chossebutton(title: "Year", isSelected: Binding(
                        get: { viewModel.selectedDuration?.rawValue ?? "" },
                        set: { newValue in
                            if let duration = DurationType(rawValue: newValue) {
                                viewModel.onDurationSelected(duration)
                            }
                        }
                    ))
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Learning Goal")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: - Save Button
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.hasChanges {
                    Button(action: { showAlert = true }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.orange)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
        }

        // MARK: - Alert
        .alert("Update Learning Goal", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Update") {
                viewModel.updateGoal()
                dismiss()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
        

        .onAppear {
            GoalManager.shared.refreshGoal()
            if let currentGoal = GoalManager.shared.currentGoal {
                viewModel.skillNameInput = currentGoal.skillName
                viewModel.selectedDuration = currentGoal.duration
            }
        }

        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        ChangeLearningGoalView()
            .preferredColorScheme(.dark)
    }
}
