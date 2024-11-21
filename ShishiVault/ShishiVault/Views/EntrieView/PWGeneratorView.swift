//
//  PWGeneratorView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import SwiftUI

struct PWGeneratorView: View {
    @State private var lenght = 8.0
    @State private var lowerCase: Bool = false
    @State private var upperCase: Bool = false
    @State private var numbers: Bool = false
    @State private var symbols: Bool = false
    
    private var sliderColor: Color {
        if lenght <= 6 {
            return Color.ShishiColorRed_
        } else if lenght > 6 && lenght <= 10 {
            return Color.orange
        } else if lenght > 10 {
            return Color.ShishiColorGreen
        }
        return Color.ShishiColorRed_
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 150, height: 4)
            .foregroundStyle(Color.ShishiColorGray)
            .padding(10)
        Spacer()
        
        VStack {
            Text("PASSWORT GENERATOR")
                .ueberschriftenTextBold()
                .padding(.vertical, 20)
            
            HStack {
                Text("Länge (\(lenght.formatted(.number))) ")
                Slider(value: $lenght, in: 1...32, step: 1.0) {
                    Text("Länge: \(lenght)")
                }.tint(sliderColor)
            }
            
            Divider()
            
            Toggle("Großbuchstaben (A-Z)", isOn: $upperCase)
                .padding(.vertical, 5)
            Toggle("Kleinbuchstaben (a-z)", isOn: $lowerCase)
                .padding(.vertical, 5)
            Toggle("Zahlen (0-9)", isOn: $numbers)
                .padding(.vertical, 5)
            Toggle("Symbole (!@#$%^&*)", isOn: $symbols)
                .padding(.vertical, 5)
            
            Divider()
            
            HStack {
                Text("Security-Level")
                    .padding(.vertical, 5)
                
                Spacer()
                
                Rectangle().frame(width: 20, height: 20)
                Rectangle().frame(width: 20, height: 20)
                Rectangle().frame(width: 20, height: 20)
                Rectangle().frame(width: 20, height: 20)
                Rectangle().frame(width: 20, height: 20)
            }
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorRed)
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        Text("Passwort erstellen")
                            .font(.title3).bold()
                            .foregroundColor(.white))
            }.padding(.horizontal, 10)
            
            
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(Color.ShishiColorRed_)
                    .padding(0)
                Text("Hinweis: Zur Erstellung dieses Passwortes wird eine externe API angesteuert.")
                    .customTextFieldText()
            }.padding(5)
            
            
        }.padding(.horizontal, 30)
        
        
        
        
        
            .presentationDetents([.fraction(0.3)])
    }
}

#Preview {
    PWGeneratorView()
}
