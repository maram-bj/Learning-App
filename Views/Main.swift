
import Foundation
import SwiftUI
import Combine

public struct MainView: View {
    @StateObject private var calendarVM = CalendarViewModel()
    @StateObject private var mainVM = MainViewModel()
    @StateObject private var goalManager = GoalManager.shared

    @State private var showPicker = false
    @State private var tempMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var tempYear: Int = Calendar.current.component(.year, from: Date())
    @State private var navigateToChangeGoal = false

    @State private var hasLearnedToday = false
    @State private var hasFreezedToday = false

    @Environment(\.modelContext) private var modelContext

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 22) {

                    // MARK: - Calendar Card

                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 365, height: 266)
                            .glassStyle()

                        VStack(spacing: 10) {
                            CalendarView(viewModel: calendarVM, showPicker: $showPicker)
                                .frame(width: 365, height: 166)
                                .padding(.top, -33)

                            VStack(spacing: 6) {
                                Divider()
                                    .frame(width: 320, height: 0.8)
                                    .background(Color.white.opacity(0.2))
                                    .padding(.top, -20)

                                // اسم الهدف
                                textBoldWhite(title: goalManager.currentGoal?.skillName ?? "—", size: 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 40)
                                    .padding(.top, -12)

                                // 🔥 و ❄️
                                if let goal = goalManager.currentGoal {
                                    StreakSectionView(
                                        streak: goal.currentStreak,
                                        freezeUsed: goal.duration.maxFreezeDays() - goal.freezeDaysRemaining
                                    )
                                } else {
                                    StreakSectionView(streak: 0, freezeUsed: 0)
                                }
                            }
                            .padding(.top, -10)
                        }
                        .padding(.vertical, 10)
                    }

                    // MARK: - Sections
                    // If goal is completed -> show Well Done, otherwise show logging buttons
                    if let goal = goalManager.currentGoal {
                        let progress = GoalProgressModel(goal: goal)
                        if progress.isGoalCompleted || goal.isCompleted {
                            wellDoneSection(goal: goal)
                        } else {
                            logButtonsSection
                        }
                    } else {
                        logButtonsSectionDisabled
                    }

                    // MARK: - Freezes info
                    // summarizing used vs total freeze days
                    VStack(spacing: 6) {
                        textregularGray3(
                            title: freezeText(for: goalManager.currentGoal),
                            size: 14
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .id(goalManager.currentGoal?.id)
                    }
                }

                // MARK: - Month Picker Overlay
                // Appears when user taps month arrow; updates the week calendar
                if showPicker {
                    Color.black.opacity(0.25)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { withAnimation(.spring()) { showPicker = false } }

                    VStack(spacing: 12) {
                        Spacer().frame(height: 100)

                        VStack(spacing: 12) {
                            HStack {
                                Text(DateFormatter().monthSymbols[tempMonth - 1] + " \(tempYear)")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Spacer()

                                Button("Today") {
                                    let now = Date()
                                    tempMonth = Calendar.current.component(.month, from: now)
                                    tempYear = Calendar.current.component(.year, from: now)
                                    calendarVM.selectedMonth = tempMonth
                                    calendarVM.selectedYear = tempYear
                                    calendarVM.updateToSelectedMonthYear()
                                }
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.orange)
                            }

                            HStack(spacing: 10) {
                                Picker(selection: $tempMonth, label: Text("")) {
                                    ForEach(1...12, id: \.self) { i in
                                        Text(DateFormatter().monthSymbols[i - 1]).tag(i)
                                    }
                                }

                                Picker(selection: $tempYear, label: Text("")) {
                                    ForEach(2000...2030, id: \.self) { y in
                                        Text("\(y)").tag(y)
                                    }
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                            .onChange(of: tempMonth) { _ in
                                calendarVM.selectedMonth = tempMonth
                                calendarVM.updateToSelectedMonthYear()
                            }
                            .onChange(of: tempYear) { _ in
                                calendarVM.selectedYear = tempYear
                                calendarVM.updateToSelectedMonthYear()
                            }
                        }
                        .padding(14)
                        .frame(width: min(UIScreen.main.bounds.width - 40, 360))
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)

                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                }
            }
            .navigationTitle("Activity")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem {
                    // Opens full calendar (all months) screen
                    NavigationLink(destination: CalendarFullView(viewModel: calendarVM)) {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }

                ToolbarSpacer(.fixed)

                ToolbarItem {
                    // Opens screen to change skill name and duration
                    NavigationLink(destination: ChangeLearningGoalView()) {
                        Image(systemName: "pencil.and.outline")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            mainVM.setup(with: modelContext)
            goalManager.setModelContext(modelContext)
            goalManager.loadGoal()

            // Reset button states every time view appears
            hasLearnedToday = false
            hasFreezedToday = false
        }
        // Reset when user changes goal inside app
        .onReceive(NotificationCenter.default.publisher(for: .goalChanged)) { _ in
            hasLearnedToday = false
            hasFreezedToday = false
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Freeze Text
    private func freezeText(for goal: GoalModel?) -> String {
        guard let goal else { return "—" }
        let maxDays = goal.duration.maxFreezeDays()
        let remaining = goal.freezeDaysRemaining
        let used = maxDays - remaining
        return "\(used) of \(maxDays) freeze days used"
    }

    // MARK: - Buttons Section
    // Log buttons section: default state vs. after user clicks 
    private var logButtonsSection: some View {
        VStack(spacing: 14) {

            // MARK: - Log as Learned
            // Default: orange circle "Log as Learned". After click: black circle with orange glow "Learned Today"
            Button {
                mainVM.logAsLearned()
                withAnimation(.easeInOut(duration: 0.3)) {
                    hasLearnedToday = true
                    hasFreezedToday = false
                }
            } label: {
                ZStack {
                    if hasLearnedToday {
                        Color.black.opacity(0.9)
                            .frame(width: 274, height: 274)
                            .cornerRadius(1000)
                            .shadow(color: Color.orange.opacity(1.5), radius: 2, x: 1.5, y: 1.5)
                            .shadow(color: Color.orange.opacity(1.4), radius: 2, x: -1.5, y: -1.5)
                        Text("Learned\nToday")
                            .lineSpacing(4)
                            .foregroundColor(.orange)
                            .font(.system(size: 36, weight: .bold))
                            .multilineTextAlignment(.center)

                        
                        
                    } else if hasFreezedToday {
                        Color.black.opacity(0.9)
                            .frame(width: 274, height: 274)
                            .cornerRadius(1000)
                            .shadow(color: Color.cyan.opacity(1), radius: 1, x: 2.5, y: 2.5)
                            .shadow(color: Color.cyan.opacity(1), radius: 1, x: -2.5, y: -2.5)
                        Text("Day\nFreezed")
                            .lineSpacing(4)
                            .foregroundColor(.cyan)
                            .font(.system(size: 36, weight: .bold))
                            .multilineTextAlignment(.center)

                    } else {
                        Color("Color")
                            .frame(width: 274, height: 274)
                            .cornerRadius(1000)
                            .shadow(color: Color.orange.opacity(1), radius: 2, x: 0.8, y: 0.8)
                            .shadow(color: Color.orange.opacity(1), radius: 2, x: -0.8, y: -0.8)
                        Text("Log as\nLearned")
                            .foregroundColor(.white)
                            .font(.system(size: 34, weight: .bold))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.bottom, 4)

            // MARK: - Log as Freezed
            // Default: cyan pill button. After click: black pill with cyan glow
            Button {
                mainVM.logAsFreezed()
                withAnimation(.easeInOut(duration: 0.3)) {
                    hasFreezedToday = true
                    hasLearnedToday = false
                }
            } label: {
                ZStack {
                    if hasFreezedToday {
                        Color.black.opacity(0.9)
                            .frame(width: 274, height: 48)
                            .cornerRadius(1000)
                            .shadow(color: Color.cyan.opacity(1), radius: 2, x: 0.8, y: 0.8)
                            .shadow(color: Color.cyan.opacity(1), radius: 2, x: -0.8, y: -0.8)
                        Text("Log as Freezed")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                    } else {
                        Color("Freez")
                            .frame(width: 274, height: 48)
                            .cornerRadius(1000)
                            .shadow(color: Color.white.opacity(0.6), radius: 1, x: 0.9, y: 0.9)
                            .shadow(color: Color.white.opacity(0.6), radius: 1, x: -0.9, y: -0.9)
                        Text("Log as Freezed")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Disabled Buttons
    // Shown when there is no active goal yet
    private var logButtonsSectionDisabled: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 274, height: 274)
                textBoldWhite(title: "Log as\nLearned", size: 34)
                    .opacity(0.5)
            }
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .cornerRadius(26)
                    .frame(width: 274, height: 48)
                textMediumWhite(title: "Log as Freezed", size: 18)
                    .opacity(0.5)
            }
        }
        .disabled(true)
    }

    // MARK: - Well Done Section
    private func wellDoneSection(goal: GoalModel) -> some View {
        VStack(spacing: 22) {
            Image(systemName: "hands.clap.fill")
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(.orange)
                .padding(.top, 20)

            Text("Well Done! ")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)

            Text("You’ve successfully completed your learning goal.\nKeep up your growth journey!")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                navigateToChangeGoal = true
            } label: {
                Text("Set New Goal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(14)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 50)
            .padding(.top, 8)

            Button {
                mainVM.setSameGoal()
            } label: {
                Text("Keep the same goal")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.orange)
                    .padding(.top, 4)
            }

            NavigationLink(destination: ChangeLearningGoalView(), isActive: $navigateToChangeGoal) {
                EmptyView()
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .padding(.bottom, 30)
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let goalChanged = Notification.Name("goalChanged")
}

// MARK: - Streak Section View
private struct StreakSectionView: View {
    let streak: Int
    let freezeUsed: Int

    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Color.orange
                    .frame(width: 160, height: 69)
                    .cornerRadius(34)
                    .opacity(0.4)

                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                    VStack(spacing: 2) {
                        textregularWhite(title: "\(streak)", size: 20)
                        textregularWhite(title: streak <= 1 ? "Day Learned" : "Days Learned", size: 12)
                    }
                }
            }

            ZStack {
                Color.freez
                    .frame(width: 160, height: 69)
                    .cornerRadius(34)
                    .opacity(0.4)

                HStack(spacing: 8) {
                    Image(systemName: "cube.fill")
                    VStack(spacing: 2) {
                        textregularWhite(title: "\(freezeUsed)", size: 20)
                        textregularWhite(title: freezeUsed <= 1 ? "Day Freezed" : "Days Freezed", size: 12)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .preferredColorScheme(.dark)
    }
}
