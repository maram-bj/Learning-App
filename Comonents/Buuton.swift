//
//  Buuton.swift
//  Learning App
//
//  Created by Maram on 27/04/1447 AH.
//

import SwiftUI

// onbording chose buttons


func chossebutton(title: String, isSelected: Binding<String>) -> some View {
    ButtonUtils.choiceButton(title: title, isSelected: isSelected)
}


// on bording start learning button
func startsbutton(color: Color, title: String, action: @escaping () -> Void) -> some View {
    ButtonUtils.startButton(color: color, title: title, action: action)
}


// Start learning button
func startbutton(color: Color, title: String, isSelected: Binding<Bool>, action: @escaping () -> Void) -> some View {
    ButtonUtils.startButton(color: color, title: title, isSelected: isSelected, action: action)
}
