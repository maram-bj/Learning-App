//
//  Functions .swift
//  Learning Challeng App
//
//  Created by Maram on 27/04/1447 AH.
//
import SwiftUI
// onbording image
func getImage() -> some View {
    Image("fire")
    .frame(width: 109, height: 109)
    .background(Color.logo)
    .clipShape(Circle())
    .glassEffect()
   //.shadow(color: Color.white.opacity(0.1), radius: 0.1, x: 0.7, y: 0.5)
    .shadow(color: Color.black.opacity(0.9), radius: 0.1, x: -0.9, y: -0.5)
    .shadow(color: Color.orange.opacity(0.9), radius: 0.6, x: 0.5, y: -0.5)
    .shadow(color: Color.white.opacity(0.02), radius: 0.1, x: 0.9, y: 0.5)


}


