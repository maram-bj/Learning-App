//
//  Buuton.swift
//  Learning App
//
//  Created by Maram on 27/04/1447 AH.
//

import SwiftUI

// onbording chose buttons


func chossebutton(title:String,isSelected:Binding<String>) -> some View {
    
    
    
    HStack{
        
        Button( action:{isSelected.wrappedValue = title})
        {
            textMediumWhite(title:title , size:17)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        .buttonStyle(.glassProminent)
        .tint(isSelected.wrappedValue==title ? Color("Color"): Color(.gray.opacity(0.1)))
        .shadow(color: Color.white.opacity(0.7), radius: 0.1, x: 0.7, y: 0.5)
        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.5, y: -0.5)
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        
        
    }//hstack
    
    .frame(width: 97, height: 48) // Set HStack size
    
    
   
}


// on bording start learning button
func startsbutton(color: Color, title: String, action: @escaping () -> Void) -> some View {
    HStack{
        Button(action: action) {
            textMediumWhite(title: title, size: 17)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.glassProminent)
        .shadow(color: Color.white.opacity(0.7), radius: 0.1, x: 0.7, y: 0.5)
        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.5, y: -0.5)
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .frame(width: 182, height: 48)
    }//h
}


// Start learning button

func startbutton(color: Color,title: String,isSelected: Binding<Bool>,action: @escaping () -> Void) -> some View {
    HStack {
        Button(action: {
            isSelected.wrappedValue = true
            action()
        }) {
            textMediumWhite(title: title, size: 17)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.glassProminent)
        .shadow(color: Color.white.opacity(0.7), radius: 0.1, x: 0.7, y: 0.5)
        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.5, y: -0.5)
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .frame(width: 182, height: 48)
        .tint(isSelected.wrappedValue ? color : Color.gray.opacity(0.3))
    }
}



//  Learned button

//Button(action: { vm.logAsLearned() }) {
//    Text(vm.bigButtonText)
//        .foregroundColor(.white)
//        .bold()
//        .frame(width: 150, height: 150)
//        .background(vm.bigButtonColor)
//        .overlay(
//            Circle()
//                .stroke(vm.bigButtonBorder, lineWidth: 4)
//        )
//        .cornerRadius(75)
//}

// freezed button




