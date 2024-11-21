//
//  PWGeneratorView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import SwiftUI

struct PWGeneratorView: View {
    @State private var lenght = 10.0
    @State private var lowerCase: Bool = true
    @State private var upperCase: Bool = true
    @State private var numbers: Bool = false
    @State private var symbols: Bool = false
    
    private var statusColor: Color {
        if statusSumCalc() <= 30 {
            return Color.ShishiColorRed_
        } else if statusSumCalc() > 30 && statusSumCalc() <= 75 {
            return Color.orange
        } else if statusSumCalc() > 75 {
            return Color.ShishiColorGreen
        }
        return Color.gray
    }
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
    private var statusWidthFromToggle: CGFloat {
        var value: CGFloat = 0
        if lowerCase {
            value += 5
        }
        if upperCase {
            value += 5
        }
        if numbers {
            value += 5
        }
        if symbols {
            value += 5
        }
        return value
    }
    private var statusWidthFromLength: CGFloat {
        var value: CGFloat = 0
        if lenght < 4 {
            value = 10
        } else if lenght >= 4 && lenght <= 6 {
            value =  55
        } else if lenght > 6 && lenght <= 10 {
            value =  85
        } else if lenght > 10 && lenght <= 16 {
            value =  100
        } else if lenght > 16 {
            value =  130
        }
        return value
    }
    private func statusSumCalc() -> CGFloat {
        var value = statusWidthFromLength + statusWidthFromToggle
        return value
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
                
                VStack {
                    ZStack(alignment: .leading) {
                        Capsule().frame(width: 150, height: 10).foregroundStyle(Color.gray.opacity(0.3))
                        Capsule().frame(width: statusSumCalc(), height: 10).foregroundStyle(statusColor)
                    }
                }
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
