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
    
    @State private var length = 10.0
    @State private var lowerCase: Bool = true
    @State private var upperCase: Bool = true
    @State private var numbers: Bool = true
    @State private var symbols: Bool = true
    @State private var pwnedAlert: Bool = false
    @State private var connectionAlert: Bool = false
    @State private var generatedPassword: String = ""
    @State private var passwordPwnedState: Int = 0
    
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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 150, height: 4).foregroundStyle(Color.ShishiColorGray).padding(10)
        
        Spacer()
        
        VStack {
            Text("PASSWORT GENERATOR")
                .font(.system(size: 25)).bold().padding(.vertical, 1)
            
            HStack {
                TextField("Passwort", text: $generatedPassword)
                    .customTextField().padding(.vertical, 15)
                
                Button(action: {
                    Task {
                        do {
                            passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: generatedPassword)
                            if passwordPwnedState == 1 {
                                pwnedAlert = true
                            }
                        } catch {
                            connectionAlert.toggle()
                        }
                    }
                }) {
                    switch passwordPwnedState {
                        case 1:
                            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                .foregroundColor(Color.ShishiColorRed_).scaleEffect(1.4).padding(.horizontal, 10)
                        case 2:
                            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                .foregroundColor(Color.ShishiColorGreen).scaleEffect(1.4).padding(.horizontal, 10)
                        case 0:
                            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                .foregroundColor(Color.ShishiColorGray).scaleEffect(1.4).padding(.horizontal, 10)
                        default:
                            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                .foregroundColor(Color.ShishiColorGray).scaleEffect(1.4).padding(.horizontal, 10)
                    }
                    
                }
                .frame(width: 25).padding(.horizontal, 10).padding(.vertical, 15)
                
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
                        .foregroundColor(Color.ShishiColorBlue).scaleEffect(1.2)
                }
                .frame(width: 25).padding(.horizontal, 10).padding(.vertical, 15)
            }
            
            PWLevelColorView(password: $generatedPassword)
                .padding(.vertical, 10)
            
            Divider()
            
            HStack {
                Text("Länge (\(length.formatted(.number))) ")
                    .frame(width: 90)
                Slider(value: $length, in: 1...32, step: 1.0) {
                    Text("Länge: \(length.formatted(.number))")
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
            
            Button {
                Task {
                    do {
                        if !upperCase && !lowerCase && !numbers && !symbols {
                            upperCase.toggle()
                            lowerCase.toggle()
                            numbers.toggle()
                        }
                        let data = try await APIRepository().getPassword(
                            length: Int(length), lowerCase: lowerCase,
                            upperCase: upperCase, numbers: numbers, symbols: symbols
                        )
                        
                        generatedPassword = data.password
                        passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: generatedPassword)
                        
                        if passwordPwnedState == 1 {
                            pwnedAlert = true
                        }
                        
                    } catch {
                        print("Fehler: \(error)")
                        connectionAlert.toggle()
                    }
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorRed).frame(height: 50).padding().foregroundColor(.white)
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
        }.padding(.horizontal, 20)
        
            .alert("Passwort unsicher!\n", isPresented: $pwnedAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: { Text("Das gewählte Passwort ist kompromittiert! Bitte wählen Sie ein anderes Passwort.") })
            .alert("Kein Internet!\n", isPresented: $connectionAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: { Text("Kein Internet zur Prüfung des Passwortes vorhanden! Eintrag wird ggf. mit unsicherem Passwort aktualisiert!") })
        
            .presentationDetents([.fraction(0.8)])
    }
}

#Preview {
    PWGeneratorView(customFieldSheet: .constant(true))
}
