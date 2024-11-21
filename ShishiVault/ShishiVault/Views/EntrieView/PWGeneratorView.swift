//
//  PWGeneratorView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import SwiftUI

struct PWGeneratorView: View {
    @State private var lenght = 6.0
    @State private var lowerCase: Bool = false
    @State private var upperCase: Bool = false
    @State private var numbers: Bool = false
    @State private var symbols: Bool = false
    
    private var sliderColor: Color {
        if lenght < 6 {
            return Color.ShishiColorRed_
        } else if lenght >= 6 && lenght <= 10 {
            return Color.orange
        } else if lenght > 10 {
            return Color.ShishiColorGreen
        }
        return Color.ShishiColorRed_
    }
    
    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 150, height: 4)
                .foregroundStyle(Color.ShishiColorGray)
                .padding(10)
        }
        Spacer()
        VStack {
            Text("Passwort Generator")
                .ueberschriftenTextBold()
                .padding()
            
            HStack {
                Text("Länge (\(lenght.formatted(.number)))")
                Slider(value: $lenght, in: 1...32, step: 1.0) {
                    Text("Länge: \(lenght)")
                }.tint(sliderColor)
            }
            
            Toggle("Großbuchstaben", isOn: $upperCase)
            Toggle("Kleinbuchstaben", isOn: $lowerCase)
            Toggle("Zahlen", isOn: $numbers)
            Toggle("Symbole", isOn: $symbols)
            
            
            
            
            
            
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
            }
            .padding(.horizontal).padding(.vertical, 5)
            
        }.padding(.horizontal, 30)
        
        
        .presentationDetents([.fraction(0.3)])
    }
}

#Preview {
    PWGeneratorView()
}
