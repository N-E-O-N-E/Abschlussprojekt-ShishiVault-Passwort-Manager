//
//  PWGeneratorView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import SwiftUI

struct PWGeneratorView: View {
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @Binding var customFieldSheet: Bool
    private let apiRepository = APIRepository()
    
    @State private var length = 10.0
    @State private var lowerCase: Bool = true
    @State private var upperCase: Bool = true
    @State private var numbers: Bool = true
    @State private var symbols: Bool = true
    @State private var generatedPassword: String = ""
    
    private var statusColor: Color {
        if statusSumCalc() <= 30 {
            return Color.ShishiColorRed_
        } else if statusSumCalc() > 30 && statusSumCalc() <= 70 {
            return Color.orange
        } else if statusSumCalc() > 70 {
            return Color.ShishiColorGreen
        }
        return Color.gray
    }
    private var sliderColor: Color {
        if length < 6 {
            return Color.ShishiColorRed_
        } else if length >= 6 && length <= 10 {
            return Color.orange
        } else if length > 10 {
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
        if length < 4 {
            value = 10
        } else if length >= 4 && length <= 6 {
            value =  55
        } else if length > 6 && length <= 10 {
            value =  85
        } else if length > 10 && length <= 16 {
            value =  100
        } else if length > 16 {
            value =  130
        }
        return value
    }
    private func statusSumCalc() -> CGFloat {
        let value = statusWidthFromLength + statusWidthFromToggle
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
                .font(.system(size: 25)).bold()
                .padding(.vertical, 10)
            
            HStack {
                TextField("Passwort", text: $generatedPassword)
                    .customTextField()
                
                Button(action: {
                    if !generatedPassword.isEmpty {
                        do {
                            try CryptHelper.shared.copyToClipboard(input: generatedPassword)
                            print("Copy to clipboard: \(generatedPassword)")
                        } catch {
                            print("Cannot copy to clipboard: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Image(systemName: "document.on.document")
                        .foregroundColor(Color.ShishiColorBlue)
                        .scaleEffect(1.2)
                }
                .frame(width: 25)
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            }
            
            Divider()
            
            HStack {
                Text("Länge (\(length.formatted(.number))) ")
                Slider(value: $length, in: 1...32, step: 1.0) {
                    Text("Länge: \(length)")
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
                Task {
                    do {
                        let data = try await apiRepository.getPassword(
                            length: Int(length), lowerCase: lowerCase,
                            upperCase: upperCase, numbers: numbers, symbols: symbols
                        )
                        let password = data
                        generatedPassword = password.password
                        
                    } catch {
                        print("Fehler: \(error)")
                    }
                }
                
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
                    .customTextFieldTextLow()
            }.padding(5)
            
        }.padding(.horizontal, 30)
        
        .presentationDetents([.fraction(0.8)])
    }
}

#Preview {
    PWGeneratorView(customFieldSheet: .constant(true))
}
