//
//  RootView.swift
//  L- New
//
//  Created by Maram on 04/05/1447 AH.

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var goalManager = GoalManager.shared

    var body: some View {
        Group {
            if goalManager.didFinishOnboarding {
                MainView()
                    .environmentObject(goalManager)
            } else {
                OnboardingView()
                    .environmentObject(goalManager)
            }
        }
        .onAppear {
            goalManager.setModelContext(modelContext)
            goalManager.refreshGoal()
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: GoalModel.self)
        .environmentObject(GoalManager.shared)
        .preferredColorScheme(.dark)
}
