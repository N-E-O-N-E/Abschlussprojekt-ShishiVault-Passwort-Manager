//
//  ContentView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI
import SwiftData

struct ComponentsExampleView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var text: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ScrollView {
            // Standardschriften ------------------------------------------------------
            
            Text("Willkommen")
                .font(.title).bold()
                .foregroundStyle(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text("Bereichsbeschreibung")
                .font(.title3)
                .foregroundStyle(ShishiColors.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text("Normaler Text")
                .font(.footnote)
                .foregroundStyle(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Text("Kleiner Text für unter Textfelder")
                .font(.caption)
                .foregroundStyle(ShishiColors.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Divider()
            // Standard-Logo und Farbe -----------------------------------------
            
            Image("ShishiLogo_600")
                .resizable().scaledToFit()
                .frame(maxWidth: 150)
                .clipShape(.rect(cornerRadius: 25))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(ShishiColors.ShishiColorBlue)
                    .frame(width: 100, height: 50)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(ShishiColors.ShishiColorRed)
                    .frame(width: 100, height: 50)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            
            
            Divider()
            // Standard-Listelemente -----------------------------------------
            
            ZStack {
                Rectangle()
                    .foregroundStyle(ShishiColors.ShishiColorPanelBackground)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 1, x: 1, y: 1)
                
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundStyle(ShishiColors.ShishiColorBlue)
                        .scaleEffect(3)
                        .padding(25)
                    
                    VStack(alignment: .leading) {
                        Text("Amazon Login")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .bold()
                        Text("Username: Mustermann")
                            .font(.footnote)
                            .foregroundStyle(ShishiColors.ShishiColorDarkGray)
                    }.padding(1)
                    Spacer()
                    Image(systemName: "info.circle")
                        .scaleEffect(1)
                        .foregroundColor(.gray)
                        .padding(20)
                }
            }
            .padding()
            
            Divider()
            // Standard-Textfeld und Password -----------------------------------------
            
            VStack {
                TextField("Textfeld", text: $text)
                    .frame(height: 30)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .border(Color.gray, width: 1)
                
                HStack {
                    Text("Benutzereingabe")
                        .font(.caption)
                        .foregroundStyle(ShishiColors.ShishiColorDarkGray)
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
                            .foregroundStyle(ShishiColors.ShishiColorDarkGray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .border(Color.gray, width: 1)
                    } else {
                        SecureField("Password", text: $text)
                            .frame(height: 30)
                            .textFieldStyle(.plain)
                            .foregroundStyle(ShishiColors.ShishiColorDarkGray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .border(Color.gray, width: 1)
                    }
                    Button(action: {
                        if !text.isEmpty {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? ShishiColors.ShishiColorBlue : ShishiColors.ShishiColorRed)
                    }
                    .padding(.horizontal, 10)
                }
                HStack {
                    Text("Passworteinagabe")
                        .font(.caption)
                        .foregroundStyle(ShishiColors.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            } .padding()
            Divider()
            // Standard-Button -----------------------------------------
            
            Button {
                // Code
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(ShishiColors.ShishiColorRed)
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        Text("Login")
                            .font(.title3).bold()
                            .foregroundColor(.white)
                    )
            }
        }
        
        
        
    }
}

#Preview {
    ComponentsExampleView()
        .modelContainer(for: Item.self, inMemory: true)
}
