//
//  Fonts.swift
//  Learning Challeng App
//
//  Created by Maram on 27/04/1447 AH.
//

import SwiftUI


func textBoldWhite(title:String , size:CGFloat) -> some View {
    Text(title)
        .font(
            .system(size: size)
        )//fontsize
        .foregroundColor(Color.fontColor1)
        .bold()
        
}//



func textsemiboldWhite(title:String , size:CGFloat) -> some View {
    Text(title)
        .font(
            .system(size: size)
        )//fontsize
        .foregroundColor(Color.fontColor1)
        .fontWeight(.semibold)
}

func textregularWhite(title:String , size:CGFloat) -> some View {
    Text(title)
        .font(
            .system(size: size)
        )//fontsize
        .foregroundColor(Color.fontColor1)
        .fontWeight(.regular)
       
  
  
}//


func textMediumWhite(title:String , size:CGFloat) -> some View {
    Text(title)
        .font(
            .system(size: size)
        )//fontsize
        .foregroundColor(Color.fontColor1)
        .fontWeight(.medium)
        
  
}//




func textregularGray2(title:String , size:CGFloat) -> some View {
    Text(title)
        .font(
            .system(size: size)
        )//fontsize
        .foregroundColor(Color.fontColor2)
        .fontWeight(.regular)
  
}//


func textregularGray3(title:String , size:CGFloat) -> some View {
    Text(title)
        .font(
            .system(size: size)
        )//fontsize
        .foregroundColor(Color.fontColor3)
        .fontWeight(.regular)
  
}//
