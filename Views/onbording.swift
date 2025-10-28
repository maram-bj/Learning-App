//
//  OnboardingView.swift
//  Learning Challeng App
//
//  Created by Maram on 27/04/1447 AH.

import SwiftUI

public struct OnboardingView: View {
    @State private var isSelected: String = ""
    @StateObject private var viewModel = OnboardingViewModel()
    @ObservedObject private var goalManager = GoalManager.shared
    @State private var isButtonSelected = false
    @Environment(\.modelContext) private var modelContext

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: Image
                HStack {
                    getImage()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 42)
                
                // MARK: Text
                VStack(alignment: .leading, spacing: 8) {
                    textBoldWhite(title: "Hello Learner", size: 34)
                    textregularGray2(title: "This app will help you learn everyday!", size: 17)
                }
                
                // MARK: Skill Input
                VStack(alignment: .leading, spacing: 4) {
                    textregularWhite(title: "I want to learn", size: 22)
                    
                    ZStack(alignment: .leading) {
                        if viewModel.skillNameInput.isEmpty {
                            textregularGray3(title: "Swift", size: 17)
                        }
                        TextField("", text: $viewModel.skillNameInput)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 14)
                    
                    Divider()
                        .background(Color.gray.opacity(0.5))
                }
                
                // MARK:  Duration
                VStack(alignment: .leading, spacing: 12) {
                    textregularWhite(title: "I want to learn it in a", size: 22)
                    HStack(spacing: 8) {
                        chossebutton(title: "Week", isSelected: $isSelected)
                        chossebutton(title: "Month", isSelected: $isSelected)
                        chossebutton(title: "Year", isSelected: $isSelected)
                    }
                }
                
                Spacer()
                
                // MARK: Start Learning Button
                HStack {
                    startbutton(
                        color: viewModel.isStartLearningButtonEnabled ? Color("Color") : Color.white.opacity(0.2),
                        title: "Start learning",
                        isSelected: $isButtonSelected
                    ) {
                        if !viewModel.skillNameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSelected.isEmpty {
                            if let durationType = DurationType(rawValue: isSelected) {
                                viewModel.onDurationSelected(duration: durationType)
                            }
                            // إنشاء الهدف
                            viewModel.onStartLearningClicked()
                            goalManager.setModelContext(modelContext)
                            goalManager.markOnboardingAsFinished()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
                
                // MARK: - NavigationLink
                NavigationLink(
                    destination: MainView()
                        .environment(\.modelContext, modelContext)
                        .environmentObject(goalManager),
                    isActive: $viewModel.shouldNavigateToActivity
                ) {
                    EmptyView()
                }
                .onAppear {
                    goalManager.setModelContext(modelContext)
                    
                    if goalManager.didFinishOnboarding {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.shouldNavigateToActivity = true
                        }
                    }
                }

            } // VStack
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } // NavigationStack
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
}
