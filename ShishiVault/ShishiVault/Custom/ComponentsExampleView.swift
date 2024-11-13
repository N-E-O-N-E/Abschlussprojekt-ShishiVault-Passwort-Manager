//
//  ContentView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI
import SwiftData

struct ComponentsExampleView: View {
    // Expemplarisches Einbinden des ModelContainers
    @Environment(\.modelContext) private var modelContext
    // Exemplarisches Einbinden des ViewModels zur Anmeldung mit Apple ID
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    @State private var text: String = ""
    @State private var isPasswordVisible: Bool = false
    
    
    var body: some View {
        
        ScrollView {
            
            
            // Standardschriften ------------------------------------------------------
            
            Text("Willkommen \(signInViewModel.userNameKeyPublic)")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.ShishiColorBlack)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text("Bereichsbeschreibung")
                .font(.title3)
                .foregroundStyle(Color.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text("Normaler Text")
                .font(.callout)
                .foregroundStyle(Color.ShishiColorBlack)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text("Kleiner Text für unter Textfelder")
                .font(.caption)
                .foregroundStyle(Color.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Divider()
            
            
            // Standard-Logo und Farbe -----------------------------------------
            
            Image("ShishiLogo_600")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
                .clipShape(.rect(cornerRadius: 25))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.ShishiColorBlue)
                    .frame(width: 100, height: 50)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.ShishiColorRed)
                    .frame(width: 100, height: 50)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            
            
            Divider()
            
            
            
            // Standard-Listelemente -----------------------------------------
            NavigationLink {
                ComponentsExampleView()
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color.ShishiColorPanelBackground)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(radius: 2, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(Color.ShishiColorBlue)
                            .scaleEffect(2.5)
                            .padding(15)
                        
                        VStack(alignment: .leading) {
                            Text("Amazon Shopping")
                                .font(.title3)
                                .foregroundStyle(Color.ShishiColorBlack)
                                .bold()
                                .padding(0)
                            Text("max1988@meinedomain.com")
                                .font(.footnote)
                                .foregroundStyle(Color.ShishiColorBlack)
                                .padding(0)
                            Divider()
                            Text("Aktualisiert am: \(Date().formatted())")
                                .font(.caption2)
                                .foregroundStyle(Color.ShishiColorDarkGray)
                                .padding(0)
                        }
                        Spacer()
                        Image(systemName: "info.circle")
                            .scaleEffect(1)
                            .foregroundColor(Color.ShishiColorDarkGray)
                            .padding(10)
                        
                    }.padding(8)
                }.padding()
            }
            
            Divider()
            
            
            // Standard-Textfeld und Password -----------------------------------------
            
            VStack {
                TextField("Textfeld", text: $text)
                    .frame(height: 30)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .border(Color.ShishiColorDarkGray, width: 1)
                
                HStack {
                    Text("Benutzereingabe")
                        .font(.caption)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
            } .padding()
            VStack {
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $text)
                            .frame(height: 30)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Color.ShishiColorDarkGray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .border(Color.ShishiColorDarkGray, width: 1)
                    } else {
                        SecureField("Password", text: $text)
                            .frame(height: 30)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Color.ShishiColorDarkGray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .border(Color.ShishiColorDarkGray, width: 1)
                    }
                    Button(action: {
                        if !text.isEmpty {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? Color.ShishiColorBlue : Color.ShishiColorRed)
                    }
                    .padding(.horizontal, 10)
                }
                HStack {
                    Text("Passworteinagabe")
                        .font(.caption)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            } .padding()
            
            
            Divider()
            
            
            // Standard-Button -----------------------------------------
            
            Button {
                signInViewModel.logout()
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorRed)
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        Text("Logout Test")
                            .font(.title3).bold()
                            .foregroundColor(.white)
                    )
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    ComponentsExampleView()
        .modelContainer(for: EntryData.self, inMemory: true)
}
